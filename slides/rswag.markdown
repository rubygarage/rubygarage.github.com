---
layout: slide
title: SWAGGER
---

![](/assets/images/swagger.png)

# RSWAG

---

### What is Swagger?

Swagger is the world’s largest framework of API developer tools for the OpenAPI Specification(OAS),
enabling development across the entire API lifecycle, from design and documentation, to test and deployment.

### What is The OpenAPI Specification ?

At the heart of the above tools is the OpenAPI Specification (formerly called the Swagger Specification).
The specification creates the RESTful contract for your API, detailing all of its resources and operations in a human and machine readable format for easy development, discovery, and integration.

--

### What is Rswag?

Rswag extends rspec-rails "request specs" with a Swagger-based DSL for describing and testing API operations.
You describe your API operations with a succinct, intuitive syntax, and it automaticaly runs the tests.
Once you have green tests, run a rake task to auto-generate corresponding Swagger files and expose them as JSON endpoints.

---

# Install the Rswag

Gemfile <!-- .element: class="filename" -->

```ruby
  gem 'rswag'
```

Run the install generator

```bash
rails g rswag:install
```
<!-- .element: class="command-line" -->

This creates all the necessary configuration files and directory structure:

```
├── config
│   ├── routes.rb < mount Swagger endpoints >
│   │
│   └── initializers
│       ├── rswag-api.rb
│       └── rswag-ui.rb
│
└── spec
    └── swagger_helper.rb
```

if you need to provide your own version of index.html. You can do this with the following generator:

```bash
rails g rswag:ui:custom
```

--

#### Lets look to `routes.rb` file

```ruby
Rails.application.routes.draw do
  ...
  mount Rswag::Api::Engine => '/your-custom-api-prefix'
  mount Rswag::Ui::Engine => '/api-docs'
  ...
end
```

#### Rswag::Api::Engine

you need define prefix where is your `swagger.json` will be placed. It must be same as you provide folder name in `rswag-api.rb`

rswag-api.rb <!-- .element: class=“filename” -->

```ruby
Rswag::Api.configure do |c|
  c.swagger_root = Rails.root.to_s + '/your-custom-api-prefix'
  ...
end

```

#### Rswag::Ui::Engine

In mounted routes you need define url where other developers can find preview for your documentation

GET https://<hostname>/api-docs/

And in `rswag-ui.rb` set path to yours `swagger.json`

rswag-ui.rb <!-- .element: class=“filename” -->

```ruby
Rswag::Ui.configure do |c|
  c.swagger_endpoint '/your-custom-api-prefix/v1/swagger.json', 'API V1 Docs'
end
```

you can define multiply swagger endpoints

--

### Preparing to create first test
When you install rswag, a file called swagger_helper.rb is added to your spec folder. This is where you define one or more Swagger documents and provide global metadata.

swargger_helper.rb <!-- .element: class=“filename” -->

```ruby
RSpec.configure do |config|
  config.swagger_root = Rails.root.join('public', 'your-custom-api-prefix')

  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      basePath: '/api/v1',
      info: {
        title: 'ToDo List API',
        version: 'v1'
      },
      produces: ['application/vnd.api+json'],
      consumes: ['application/vnd.api+json'],
      securityDefinitions: {
        access_token: { type: 'apiKey', in: 'header', name: 'access-token' },
        token_type: { type: 'apiKey', in: 'header', name: 'token-type' },
        client: { type: 'apiKey', in: 'header', name: 'client' },
        uid: { type: 'apiKey', in: 'header', name: 'uid' }
      },
      security: [
        { access_token: [], token_type: [], client: [], uid: [] }
      ],
      paths: {},
      definitions: {}
    }
  }
end
```

let's look at it in order ...

--

#### First let Rspec to known where is our `swagger.json` files

```ruby
RSpec.configure do |config|
  config.swagger_root = Rails.root.join('public', 'your-custom-api-prefix')
  ...
end
```

#### If you need more than one version your API

you can add `'api_version/swagger.json' => {}` part with diferent options

```ruby
RSpec.configure do |config|
...
  config.swagger_docs = {
    ...
    'v2/swagger.json' => {
      ...
    },
    'v3/swagger.json' => {
      ...
    }
  }
end
```

--

#### Each version you can configure:

`swagger: '2.0'`
Swagger (OpenAPI) Specification version

`basePath: '/api/v1'`
Base path to your specs `Rails.root/spec/requests/api/v1`

`info: { title: 'ToDo List API', version: 'v1' }`
Simple add `title` and `version` to global metadata

`produces: ['application/vnd.api+json']`
Set media type your API responses `json_api`

`consumes: ['application/vnd.api+json']`
Set what type requests receive your API `json_api`

`securityDefinitions: { ... } `
define specification of different security schemes and their applicability to operations in an API

`security: [{ access_token: [], token_type: [], client: [], uid: [] }]`
Attribute at the operation level to specify which schemes, if any, are applicable to that operation.

`paths: {} and definitions: {}`
You can provide global metadata, for example - define all your api paths and use it in specs

---
### Let's Create an integration spec to describe and test your API.

create file `spec/requests/api/v1/auth/sign_in_spec.rbsign_in_spec.rb`
sign_in_spec.rb <!-- .element: class=“filename” -->

```ruby
RSpec.describe 'Sign In', type: :request do
  path '/auth/sign_in' do
    post 'Sign In' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body, in: :body, required: true, schema: {
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %i[email password]
      }

      response '200', 'User information' do
        let(:user) { create(:user, password: 'password') }

        it 'returns User information' do |example|
          post api_v1_user_session_path, params: { email: user.email, password: 'password' }

          expect(response.headers).to include('access-token', 'token-type', 'client', 'expiry', 'uid')

          assert_response_matches_metadata(example.metadata)
        end

        examples 'application/json' => response_schema(:auth, :sign_in)
      end

      response '401', 'Invalid login credentials' do
        it 'returns an error' do |example|
          post api_v1_user_session_path, params: {}

          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end
end
```

##### let's take it step by step

--
`RSpec.describe 'Sign In', type: :request do`
Set spec type to `request`

`path '/auth/sign_in' do ... end`
Set request API path

`post 'Sign In' do ... end`
Describe request type with name for documentation

`tags 'Authentication'`
Set name one of the main section

`consumes 'application/json' and produces 'application/json'`
Define that Sign in receive and respond only in `json` format

`parameter name: :body, in: :body, required: true, schema: { ... }`
Specify that in request body requried parameter `:body` with `schema: {}`

```ruby
schema: {
  properties: {
    email: { type: :string },
    password: { type: :string }
  },
  required: %i[email password]
}
```
In `schema` we define what propertis come inside request body and their type, also we can specify which of these paramentres is required.

--

##### Response

`response '200', 'User information' do ... end `
In this block we Describe what user receive if response have status `200 OK`

`assert_response_matches_metadata(example.metadata)`
Rswag method checks that response data required and have correct type, if not - test fails

`examples 'application/json' => response_schema(:auth, :sign_in)`
Write response example

Same way you provide tests to all actions in your controller

---

#### Finally generate the Swagger JSON file(s)

```ruby
rake rswag:specs:swaggerize
```
Its command runs your request tests and create `swagger.json` file(s)
Spin up your app and check out the awesome, auto-generated docs at `https://<hostname>/api-docs/`
---

# The End
