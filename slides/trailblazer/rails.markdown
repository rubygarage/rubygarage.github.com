---
layout: slide
title: Integrating Trailblazer with Rails API
---

# Integrating Trailblazer with Rails API
Step by step tutorial of creating rails application using trailblazer stack

---

## Project structure

Trailblazer’s file structure organizes by **CONCEPT**, and then by technology. It embraces the **COMPONENT STRUCTURE** of your code. The modular structure simplifies refactoring in hundreds of legacy production apps. To avoid constants naming collision with your `ActiveRecord` models, it’s better to name your concepts using plural nouns.


It’s ok to use nested concepts when your business logic belongs to specific scope. For example you have a project that has notification settings. You can place your `notification_settings` concept under projects.

--

```
- app
  - concepts
    - api
      - v1
        - projects
          - contract
            | create.rb
            | index.rb
            | show.rb
          - operation
            | create.rb
            | index.rb
            | show.rb
          - policy
            | create.rb
          - representer
            | create.rb
            | index.rb
            | show.rb
          - notification_settings
            + contract
            + operation
            + representer
        + user
        + lib
  + endpoints
  - controllers
    - api
      - v1
        | users_controller.rb
        | projects_controller.rb
```


---

## Testing

In Trailblazer, you write operation integration tests. Operations encapsulate all business logic and are single-entry points to operate your application.

**There’s no need to test contract/representer etc in isolation.**

You need to test your operation with all dependencies.

```
- spec
  + api_doc
  - concepts
    - api
      - v1
        - projects
          + decorators
          - notification_settings
            | create_spec.rb
          | create_spec.rb
          | index_spec.rb
        + user
```

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

Configurate `config/initializers/trailblazer.rb`

```ruby
require 'reform'
require 'reform/form/dry'
require 'jsonapi/serializable'

Rails.application.configure do
  config.trailblazer.use_loader = false
  config.trailblazer.application_controller = 'ApiController'
end

```

--

Due to historic reasons the `trailblazer-loader` gem comes pre-bundled with `trailblazer-rails`.
So you need to set `config.trailblazer.use_loader` to `false` to use Rails naming convention which is recommended now.

Now it’s a Trailblazer convention to put `[ConceptName]::Operation` in one line: it will force Rails to load the concept name constant, so you don’t have to reopen the class yourself.

```ruby
# app/concepts/sessions/operation/create.rb

module Sessions::Operation
  class Create < Trailblazer::Operation
    # ...
  end
end
```

This will result in a class name Product::Operation::Create.

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
          password_confirmation: '!1password',
          redirect_to: '/login'
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

Create default handlers for outcomes, and `endpoint` helper to conveniently call custom Endpoint with default handlers.

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

`app/concepts/api/users/operation/register.rb`

```ruby
module Api::V1::Users::Operation
  class Register < Trailblazer::Operation
    step Model(User, :new)
    step Contract::Build(constant: Api::V1::Users::Contract::Register)
    step Contract::Validate()
    step Contract::Persist()
    step :send_confirmation
    step :renderer_options

    def send_confirmation
      redirect_to = ctx['contract.default'].redirect_to
      UserMailer.confirmation(model, redirect_to).deliver_later
    end

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

### Implement user register contract using dry-rb validations

`app/concepts/api/users/contract/register.rb`

```ruby
module Api::V1::Users::Contract
  class Register < Reform::Form
    include Dry

    property :email
    property :password
    property :password_confirmation
    property :redirect_to

    validation :default do
      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
      required(:timezone).filled(:str?)
      required(:password).filled(
        :str?,
        min_size?: Constants::Shared::PASSWORD_MIN_LENGTH,
        format?: Constants::Shared::PASSWORD_REGEX
      ).confirmation
      required(:redirect_to).filled(format?: Constants::Shared::REDIRECT_TO_REGEX)
    end

    validation :email_uniqueness, if: :default, with: { form: true } do
      configure do
        config.messages = :i18n
        config.namespace = :user
        option :form
      end

      validate(email_unique?: [:email]) do |email|
        model = form.model
        model.class.where.not(id: model.id).where(attr_name => value).empty?
      end
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

### Test user register operation

```ruby
RSpec.describe Api::V1::User::Operations::Register do
  subject(:result) { described_class.call(params: params) }

  let(:valid_params) { attributes_for(:user) }
  let(:params) { {} }

  describe 'Success' do
    let(:params) { valid_params }

    it 'creates user with company and role' do
      expect(UserMailer).to receive_message_chain(:confirmation, :deliver_later)
        .with(be_kind_of(User), url).with(no_args) { true }

      expect { result }.to change(User, :count)from(0).to(1)

      expect(result[:model]).to be_persisted
      expect(result[:model]).to an_instance_of User
      expect(result).to be_success
    end
  end

  describe 'Fail' do
    context 'with empty keys' do
      let(:errors) do
        {
          email: ['must be filled'],
          password: ['must be filled', 'size cannot be less than 6'],
          redirect_to: ['must be filled']
        }
      end

      it 'has validation errors' do
        expect(result).to be_failure
        expect(result['contract.default'].errors.messages).to match errors
      end
    end

    context 'with invalid password' do
      let(:params) { valid_params.merge(password: 'password', password_confirmation: 'password') }
      let(:errors) do
        {
          password: ['is in invalid format']
        }
      end

      it 'has validation errors' do
        expect(result).to be_failure
        expect(result['contract.default'].errors.messages).to match errors
      end
    end

    context 'with unconfirmed password' do
      let(:params) { valid_params.merge(password_confirmation: 'no') }
      let(:errors) { { password_confirmation: ["doesn't match"] } }

      it 'has validation errors' do
        expect(result).to be_failure
        expect(result['contract.default'].errors.messages).to match errors
      end
    end

    context 'with non unique email' do
      let(:user) { create(:user) }
      let(:params) { valid_params.merge(email: user.email) }

      let(:errors) { { email: ['This email is already registered. Please, log in.'] } }

      it 'has validation errors' do
        expect(result).to be_failure
        expect(result['contract.default'].errors.messages).to match errors
      end
    end
  end
end
```

---

## Example

[Repository with Example](https://github.com/rubygarage/trailblazer-courses)

## Task

Extend example with additional features described in specification.


[Task and Example Specification](/slides/trailblazer/task_specification)

---

# The End
