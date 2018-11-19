---
layout: slide
title: Integrating Trailblazer with Rails API
---

# Integrating Trailblazer with Rails API
Step by step tutorial of creating rails application using trailblazer stack

---

## Project structure

---

## Testing

---

## Setting up

Let's create new rails application using:

```ruby
rails new api-app -T --database=postgresql --api
```

--

Add trailblazer dependencies in your `Gemfile`:

```ruby
# Trailblazer bundle
gem 'trailblazer-endpoint', github: 'trailblazer/trailblazer-endpoint'
gem 'trailblazer-rails'
```
`trailblazer-endpoint` is generic HTTP handlers for operation results
`trailblazer-rails` will automatically pull trailblazer and trailblazer-loader.

--

Add RSpec dependencies.

The Rspec team officially states controller specs are now discouraged. So we will implement request specs using `json_matchers` to match serialized responses.

```ruby
group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'json_matchers'
end
```

--

Next add devise gem to generate user model which we will use for authentication:

```ruby
# Authentication
gem 'devise'
```

Run devise installer to generate default config:
```bash
rails generate devise:install
```
Create user model using devise generator:
```bash
rails generate devise user
```
Run migrations to create users table in the database:
```bash
rails db:migrate
```

--

We will use `jsonapi-rb` gem for serializing documents using jsonapi 1.0 specification.

```ruby
gem 'jsonapi-rails', github: 'jsonapi-rb/jsonapi-rails'
```

--

Dox generates API documentation from Rspec controller/request specs in a Rails application.

```ruby
group :test do
  gem 'dox', require: false
end
```

---

## Create first request test.

`spec/requests/api/v1/user/registration_spec.rb`

```ruby
RSpec.describe 'Api::V1::User::Registration', type: :request do
  include ApiDoc::V1::User::Registration::Api

  describe 'POST #create' do
    include ApiDoc::V1::User::Registration::Create

    describe 'Success' do
      let(:valid_params) do
        {
          email: FFaker::Internet.email,
          password: '!1password',
          password_confirmation: '!1password'
        }.to_json
      end

      before { post '/api/v1/user/registration', params: valid_params, headers: json_api_headers }

      it 'renders created user', :dox do
        expect(response).to be_created
        expect(response).to match_json_schema('user/registration')
      end
    end
  end
end
```

---

`config/routes.rb`

```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :user do
        resource :registration, only: :create
      end
    end
  end
end
```

---

We can now generate expected json schema for our request spec.
You can find JsonApi Schema definition following this link JSON API schema example
Also you can use service like https://www.jsonschema.net/ to generate required json schemas.

`spec/support/api/schemas/user/registration.json`:

```json
{
  "definitions": {},
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "file:/user/resgistration.json#",
  "type": "object",
  "title": "User Registration Schema",
  "required": [
    "data"
  ],
  "properties": {
    "data": {
      "$id": "#/properties/data",
      "type": "object",
      "title": "The Data Schema",
      "required": [
        "id",
        "type",
        "attributes"
      ],
      "properties": {
        "id": {
          "$id": "#/properties/data/properties/id",
          "type": "string",
          "title": "The Id Schema",
          "default": "",
          "examples": [
            "14"
          ],
          "pattern": "^(.*)$"
        },
        "type": {
          "$id": "#/properties/data/properties/type",
          "type": "string",
          "title": "The Type Schema",
          "default": "",
          "examples": [
            "users"
          ],
          "pattern": "^(.*)$"
        },
        "attributes": {
          "$id": "#/properties/data/properties/attributes",
          "type": "object",
          "title": "The Attributes Schema",
          "required": [
            "email"
          ],
          "properties": {
            "email": {
              "$id": "#/properties/data/properties/attributes/properties/email",
              "type": "string",
              "title": "The Email Schema",
              "default": "",
              "examples": [
                "email@email.em"
              ],
              "pattern": "^(.*)$"
            }
          },
          "additionalProperties": false
        }
      }
    }
  }
}

```

---

Create default endpoint using trailblazer-endpoint with dry-matcher

`app/endpoints/api/endpoint.rb`:

```ruby
module Api
  class Endpoint < Trailblazer::Endpoint
    Matcher = Dry::Matcher.new(
      created: Dry::Matcher::Case.new(
        match:   ->(result) { result.success? && result['model.action'] == :new },
        resolve: ->(result) { result }
      ),
      invalid: Dry::Matcher::Case.new(
        match:   ->(result) { result.failure? && result['result.contract.default'] && result['result.contract.default'].failure? },
        resolve: ->(result) { result }
      )
    )

    def matcher
      Api::Endpoint::Matcher
    end
  end
end
```

---

`app/controllers/api_controller.rb`

```ruby
class ApiController < ApplicationController
  include DefaultEndpoints
  include JsonapiParsing
  include JsonapiPointers
  include JsonapiContentTypeRestriction
end
```

---

Create default handlers for outcomes, and `endpoint` helper to conviniently call custom Endpoint with default handlers.

`app/controllers/concerns/default_endpoints.rb`:

```ruby
module DefaultEndpoints
  protected

  def default_handler
    lambda do |m|
      m.created do |result|
        render jsonapi: result[:model], **result[:renderer_options], status: :created
      end
      m.invalid do |result|
        render jsonapi_errors: result['contract.default'].errors,
                        class: {
                          'Reform::Form::ActiveModel::Errors': JSONAPI::Rails::SerializableActiveModelErrors
                          },
                        status: :unprocessable_entity
      end
    end
  end

  def endpoint(operation_class, _options = {}, &block)
    Api::Endpoint.call(operation_class, default_handler, { params: params.to_unsafe_h }, &block)
  end
end
```

---

Now we can use endpoint method in all our actions.

`controllers/api/v1/user/registrations_controller.rb`:

```ruby
module Api
  module V1
    module User
      class RegistrationsController < ApiController
        def create
          endpoint Api::V1::Users::Operation::Register
        end
      end
    end
  end
end
```

---

### Implement user register operation

`app/concepts/api/users/operaion/register.rb`

```ruby
module Api::V1::Users::Operation
  class Register < Trailblazer::Operation
    step Model(User, :new)
    step Contract::Build(constant: Api::V1::Users::Contract::Register)
    step Contract::Validate()
    step Contract::Persist()
    step :renderer_options

    def renderer_options(ctx, **)
      ctx[:renderer_options] = {
        class: {
          User: Api::V1::Users::Representer::Register
        }
      }
    end
  end
end
```

---

### Implement user register contract using activemodel validations

`app/concepts/api/users/contract/register.rb`

```ruby
module Api::V1::Users::Contract
  class Register < Reform::Form
    property :email
    property :password
    property :password_confirmation

    validate :password_ok?

    def password_ok?
      errors.add(:password, I18n.t('errors.password_missmatch')) if password != password_confirmation
    end
  end
end
```

---

### Implement user register representer.

`app/concepts/api/users/representer/register.rb`

```ruby
module Api::V1::Users::Representer
  class Register < JSONAPI::Serializable::Resource
    type 'users'


    attributes :email
  end
end
```

---

## More advanced examples

---

# The End
