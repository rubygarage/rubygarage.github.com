---
layout: slide
title:  Graphql
---

# GraphQL

![](/assets/images/graphql/graphql-icon.svg)

--

## What *IS NOT* GraphQL?

- Not a database technology

- Not a library to install

- Not a language or framework specific

--

## What *IS* GraphQL?

- A new API standard developed by Facebook that provides a more efficient, powerful and flexible alternative to REST

- A client specified query language for APIs - enables declarative data fetching where a client can specify exactly what data it needs

- A server spec - creates a uniform API across your entire application without being limited by a specific language, framework or database

---

# Advantages of GraphQL

---

## No more Over- and Underfetching

### One of the most common problems with REST is that of over- and underfetching. This happens because the only way for a client to download data is by hitting endpoints that return fixed data structures.

--

## Imagine...

### That we need to fetch user name and the first three of user tasks' titles for some kind of dashboard

--

## Using REST

```json
  # GET /user/:id
  {
    "user": {
      "id": "unqueUserId",
      "name": "Gogi",
      "email": "gogi@google.com",
      "address": {...},
      ...
    }
  }

  # GET /user/:id/tasks
  {
    "tasks": [{
      "id": "unqueUserId",
      "title": "Make sandwitch",
      "description": "...",
      "comments": {...},
      ...
    },
    ...]
  }

 ```

--

## Using GraphQL

```graphql
  query {
    user(id: 1) {
      id
      name
      tasks(first: 3) {
        title
      }
    }
  }
```

``` json
  {
    "data": {
      "user": {
        "id": 1,
        "name": "Gogi",
        "tasks": [
          { "title": "Make sandwitch" },
          { "title": "Eat sandwitch" },
          { "title": "Go to the toilet" }
        ]
      }
    }
  }
```

---

## Faster frontend development

### Thanks to the flexible nature of GraphQL, changes on the client-side can be made without any extra work on the server. Since clients can specify their exact data requirements, no backend engineer needs to make adjustments when the design and data needs on the frontend change. Also frontend engineers can stub schema and work before backend is ready.

---

## Less boilerplate work on the backend

`POST /graphql`

### Only ONE route is required for the GraphQL server

```ruby
  # app/controllers/graphql_controller.rb
  class GraphqlController < ApplicationController
    def execute
      ...
    end
  end
```

```ruby
  # config/routes.rb
  MyApp.routes.draw do
    post "/graphql", to: "graphql#execute"
  end
```

---

## GraphQL limitations

### - File downloads
GraphQL uses JSON format, which represents as text format, not as binary.
You can send a file as base64 string or send a download link.

### - Incoming Webhooks
You will need to add the REST endpoints to listen for events from services like Stripe. 

---

## Schema & Type System

### GraphQL uses a strong type system to define the capabilities of an API. All the types that are exposed in an API are written down in a schema using the GraphQL Schema Definition Language (SDL). This schema serves as the contract between the client and the server to define how a client can access the data.

--

### Example

```graphql
type Query {
  user(id: ID!): User
}

type Mutation {
  addTask(title: String!, userId: ID!): Task
}

type User {
  id: ID!
  name: String
  email: String
  birthday: String
  tasks: [Task]
}

type Task {
  id: ID!
  title: String
  description: String
  position: Integer
}
```

---

## Setup GraphQL server using Ruby on Rails

Add to Gemfile

```ruby
  gem 'graphql', '1.9.14'
```

Then run

```bash
  $ bundle
  $ rails generate graphql:install
```

--

### It generates base structure

```
- app
  - controllers
    | graphql_controller.rb
  - graphql
    + mutations
    + queries
    - types
      | base_object.rb
      | base_argument.rb
      | base_field.rb
      | base_enum.rb
      | base_input_object.rb
      | base_interface.rb
      | base_scalar.rb
      | base_union.rb
      | query_type.rb
      | mutation_type.rb
    | graphql_meetup_schema.rb
```

--

#### Graphql Schema
```ruby
  # app/graphql/graphql_meetup_schema.rb
  class GraphqlMeetupSchema < GraphQL::Schema
    mutation(Types::MutationType)
    query(Types::QueryType)
  end
```

#### Graphql base types
```ruby
  # app/graphql/types/guery_type.rb
  module Types
    class QueryType < Types::BaseObject
      # Add root-level fields here.
      # They will be entry points for queries on your schema.

      field :test_field, String, null: false, description: "An example field added by the generator"

      def test_field
        "Hello World!"
      end
    end
  end
```

```ruby
  # app/graphql/types/mutation_type.rb
  module Types
    class MutationType < Types::BaseObject
      field :test_field, String, null: false, description: "An example field added by the generator"

      def test_field
        "Hello World"
      end
    end
  end
```

--

#### Route
```ruby
  # config/routes.rb
  Rails.application.routes.draw do
    post '/graphql', to: 'graphql#execute'
  end
```

#### And controller
```ruby
  # app/controllers/graphql_controller.rb
  class GraphQLController < ApplicationController
    def execute
      variables, query, operation_name = params.values_at(:variables, :query, :operationName)

      context = { current_user: current_user }

      result = GraphqlMeetupSchema.execute(
        query,
        variables: ensure_hash(variables),
        context: context,
        operation_name: operation_name
      )

      render json: result
    end

    private

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      return {} unless ambiguous_param

      case ambiguous_param
      when String
        ambiguous_param.present? ? ensure_hash(JSON.parse(ambiguous_param)) : {}
      when Hash, ActionController::Parameters
        ambiguous_param
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end

```

--

### GraphQL generator will offer you to install GraphiQL app and add `gem "graphiql-rails"` to Gemfile.
### GraphiQL is a nice IDE that helps you to test your GraphQL queries.

--

#### It is available under `/graphiql` path and looks like this:

![](/assets/images/graphql/graphiql-example.png)

#### Just write the query you want to test and press play button

--

### A better GraphiQL alternatives that allow you to configure HTTP headers:

- GraphQL Playground: https://github.com/prisma-labs/graphql-playground
- Insomnia: https://github.com/Kong/insomnia

GraphQL Playground demo: https://www.graphqlbin.com/v2/6RQ6TM

--

### Starting from version 7.2 Postman supports GraphQL
The only disadvantage of Postman is that you need to upload you GraphQL schema in order to have the autocomplete and that it doesn't have documentation sidebar

![](/assets/images/graphql/graphql-postman.png)

---

## Types, fields and arguments

---

### Types

#### Types describs data units in the system. There are such types as:

- Default scalar types
- Object types
- Custom scalar types
- Enum types
- Interface types

--

### Default scalar types

- Int: A signed 32‐bit integer.
- Float: A signed double-precision floating-point value.
- String: A UTF‐8 character sequence.
- Boolean: true or false.
- ID: The ID scalar type represents a unique identifier, often used to refetch an object or as the key for a cache. The ID type is serialized in the same way as a String; however, defining it as an ID signifies that it is not intended to be human‐readable.

--

#### Ruby example:
```ruby
  Types::Product = GraphQL::ObjectType.define do
    name "Product"

    global_id_field

    field :name, types.String
    field :price, types.Float
    field :rating, types.Integer
    field :recommended, types.Boolean
  end
```

#### Graphql schema example:
```graphql
  type Product {
    id: ID
    name: String
    price: Float
    rating: Integer
    recommended: Boolean
  }
```

--

### Object Types

#### The most basic components of a GraphQL schema are object types, which just represent a kind of object you can fetch from your service, and what fields it has.

#### Ruby example:
```ruby
  Types::Product = GraphQL::ObjectType.define do
    ...
  end
```

#### Graphql schema example:
```graphql
type Product {
  ...
}
```

--

### Custom scalar types

#### There is also a way to specify custom scalar types. For example, we could define a Time type:

```ruby
  TimeType = GraphQL::ScalarType.define do
    name "Time"
    description "Time since epoch in seconds"

    coerce_input ->(value, ctx) { Time.at(Float(value)) }
    coerce_result ->(value, ctx) { value.to_f }
  end

  Types::Product = GraphQL::ObjectType.define do
    ...
    field :createdAt, TimeType
  end
```

```graphql
  scalar Time

  type Product {
    ...
    createdAt: Time
  }
```

--

### Enum types

#### Enumeration types are a special kind of scalar that is restricted to a particular set of allowed values.

Example:

```ruby
  LanguageEnum = GraphQL::EnumType.define do
    name "Languages"
    description "Programming languages for Web projects"

    value "PYTHON", "A dynamic, function-oriented language"
    value "RUBY", "A very dynamic language aimed at programmer happiness"
    value "JAVASCRIPT", "Accidental lingua franca of the web"
  end

  Types::Product = GraphQL::ObjectType.define do
    ...
    field :language, LanguageEnum
  end
```

```graphql
  enum Languages {
    PYTHON
    RUBY
    JAVASCRIPT
  }

  type App {
    ...
    language: Languages
  }
```

--

### Interface types

#### Like many type systems, GraphQL supports interfaces. An Interface is an abstract type that includes a certain set of fields that a type must include to implement the interface.

```ruby
  DeviceInterface = GraphQL::InterfaceType.define do
    name "Device"
    description "Hardware devices for computing"

    field :ram, types.String
    field :processor, ProcessorType
    field :releaseYear, types.Int
  end

  Laptoptype = GraphQL::ObjectType.define do
    implements DeviceInterface

    ...
  end
```

```graphql
  interface Device {
    ram: String
    processor: Processor
    releaseYear: Int
  }

  type Laptop implements Device {
    id: ID
    ram: String
    processor: Processor
    releaseYear: Int
    ...
  }
```

---

## Type Modifiers

Object types, scalars, and enums are the only kinds of types you can define in GraphQL. But when you use the types in other parts of the schema, or in your query variable declarations, you can apply additional type modifiers that affect validation of those values.

--

### Non-Null modifier

```ruby
  Types::Product = GraphQL::ObjectType.define do
    ...
    field :title, !types.String
  end
```

```graphql
  type Product {
    title: String!
  }
```

Here, we're using a String type and marking it as Non-Null by adding an exclamation mark, ! after the type name in graphql or before the type object in Ruby. This means that our server always expects to return a non-null value for this field, and if it ends up getting a null value that will actually trigger a GraphQL execution error, letting the client know that something has gone wrong.

--

### List modifier

We can use a type modifier to mark a type as a List, which indicates that this field will return an array of that type.

```ruby
  Types::Task = GraphQL::ObjectType.define do
    ...
  end

  Types::TodoList = GraphQL::ObjectType.define do
    ...
    field :tasks, [Types::Task]
  end
```

```graphql
  type Task {
    ...
  }

  type TodoList {
    tasks: [Task]
  }
```

---

## Fields and arguments

--

### Fields

#### Fields are like functions - they receive arguments and have return type

#### `graphql-ruby` returns fields value from parent object by default.

```ruby
  Types::Product = GraphQL::ObjectType.define do
    name "Product"

    # this will return the price from products table
    field :price, types.Float
  end
```

--
### Resolvers

`grapqhl-ruby` allows you to assign custom resolvers to fields that allows you to customize field return value.
Resolver is expected to be an object that has a public method call (either proc object or class) that receives three arguments:

- obj - parent object, the object that query or mutation resolvers return
- args - arguments for this field
- ctx - context of the request that you send down in controller

and return value of the field type or nil if allowed

```ruby
  Types::Product = GraphQL::ObjectType.define do
    ...
    field :discountedPrice, types.Float do
      resolver -> (obj, args, ctx) do
        obj.price * 0.5
      end
    end
  end
```

--

### Arguments

#### Fields accepts arguments

#### The most common usecase is an `id`:

```graphql
  query {
    product(id: 1) {
      id
      title
      price(currency: "USD")
    }
  }
```

```ruby
  Types::ProductType = GraphQL::ObjectType.define do
    ...
    field :price, types.Float do
      resolver -> (obj, args, ctx) do
        SomeExchangeService.call(obj, args["currency"])
      end
    end
  end

  Types::QueryType = GraphQL::ObjectType.define do
    name 'Query'

    field :product, Types::ProductType do
      resolve -> (obj, args, ctx) { Product.find(args["id"]) }
    end
  end
```

You can get an access to field arguments in resolver using second argument (args).

---

## Queries and Mutations

---

### Schema definition

#### `graphql-ruby` generator creates schema file for us, so we don't need to create it

```ruby
  # app/graphql/app_schema.rb
  AppSchema = GraphQL::Schema.define do
    query Types::QueryType
    mutation Types::MutationType
  end
```

#### Schema must always include two root fields `query` and `mutation`. Those two includes other queries - for fetching data and mutations - for performing some changes in database

---

### Queries

#### `graphql-ruby` generator creates query type as well

#### Inside the `query type` you describe the fields which are actually could be fetched from server

`app/graphql/types/query_type.rb`

```ruby
class Types::QueryType < GraphQL::Schema::Object
  field :product,
        resolver: Resolvers::Product,
        description: 'Fetch a product'
end
```

`app/graphql/resolvers/product.rb`

```ruby
class Resolvers::Product < GraphQL::Schema::Resolver
  type Types::ProductType, null: false

  argument :id, ID, required: false

  def resolve(id: nil)
    Product.find(id)
  end
end

```

#### `Attention!` Query fields resolvers should always return the instance of object or an collection of objects the field type expects or nil if allowed.

--

#### Now let's query products form graphql server

```graphql
  query {
    product(id: 10) {
      id
      name
    }
  }
```

```json
  {
    "data": {
      "product": {
        "id": 10,
        "name": "..."
      }
    }
  }

```

---

## Mutations

#### Mutations are queries with side effects. Mutations are used to mutate your data. In order to use mutations you need to define a mutation root type that allows for defining fields that can mutate your data.

`app/graphql/types/mutation_type.rb`

```ruby
class Types::MutationType < ::Types::Base::Object
  description '...'

  field :product_create, mutation: Mutations::Product::Create
end
```

`app/graphql/mutations/product/create.rb`

```ruby
class Mutations::Product::Create < GraphQL::Schema::Mutation
  description '...'

  type Types::ProductType

  argument :input, Types::Inputs::ProductCreateInput, required: true

  def resolve(input:)
    # here you will create product with data in input
  end
end
```

--

### Also you create input object, that you will pass from the outside

`app/graphql/types/inputs/product_create_input.rb`

```ruby
class Types::Inputs::ProductCreateInput < GraphQL::Schema::InputObject
  graphql_name 'ProductCreateInput'
  description 'Input for product creation'

  argument :name, String, required: true,
                          description: 'Name',
                          prepare: ->(name, _ctx) { name.strip }
end

```

--

The mutation query would look like:

```graphql
mutation {
  productCreate(input: { name: 'Test' }) {
    id
    name
  }
}

```

And response:

```json
{
  "data": {
    "productCreate": {
      "id": 10,
      "name": "Title"
    }
  }
}
```

---

## Error Handling

--

### Schema validation errors

#### If you try to send an invalid request to the server, such as a request with a field that doesn’t exist, you’ll already get a pretty good error message back. For example:

```graphql
  query {
    tasks {
      unknown
    }
  }
```

```json
  {
    "errors": [
      {
        "message": "Field 'unknown' doesn't exist on type 'Task'",
        "locations": [
          {
            "line": 3,
            "column": 5
          }
        ],
        "fields": [
          "query",
          "tasks",
          "unknown"
        ]
      }
    ]
  }
```

--

### Application errors

#### You can manually return instance of GraphQL::ExecutionError from resolver to respond with custom error. For example:

```ruby
  class Resolvers::AddTask < GraphQL::Function
    argument :todoListId, !types.ID
    argument :title, !types.String

    type Types::TaskType

    def call(_obj, args, _ctx)
      todo_list = TodoList.find(args["todoListId"])
      task = todo_list.tasks.build(title: args["title"])

      if task.save
        tasks
      else
        GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
```

--

#### Let's perform the mutation:

```graphql
  mutation {
    addTask(title: "Short T") {
      id
      title
    }
  }
```

#### And what we get:

```json
  {
    "data": {
      "addTask": null
    },
    "errors": [
      {
        "message": "Invalid input: Title is too short (minimum 8 characters)",
        "locations": [
          {
            "line": 2,
            "column": 3
          }
        ],
        "fields": [
          "mutation",
          "addTask"
        ]
      }
    ]
  }
```

--

### Form input errors

#### Previous example is good when you want to show errors as flash message, but it won't work if you need to show errors for each field in form. For this case you can create your own custom error. For example:

```graphql
  class Mutations::ValidationError < GraphQL::ExecutionError
    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    def to_h
      entity.errors.to_hash.transform_keys { |key| key.to_s.camelize(:lower) }
    end
  end
```

#### And return it in resolver:

```ruby
  class Resolvers::AddTask < GraphQL::Function
    ...

    def call(_obj, args, _ctx)
      todo_list = TodoList.find(args["todoListId"])
      task = todo_list.tasks.build(title: args["title"])

      if task.save
        tasks
      else
        Mutations::ValidationError.new(task)
      end
    end
  end
```

--

#### Mutation:

```graphql
  mutation {
    addTask(title: "Short T") {
      id
      title
    }
  }
```

#### Response:

```json
  {
    "data": {
      "addTask": null
    },
    "errors": [
      { title: ["is too short (minimum 8 characters)"] }
    ]
  }
```

#### Now you have errors assosiated to the field name and you can easily show them on your form

---

## Let's start creating an application

--

## Create request test for sign up

`spec/requests/graphql/mutations/user/sign_up_spec.rb`

```ruby
describe 'mutation userSignup', type: :request do
  let(:default_variables) do
    {
      email: FFaker::Internet.email,
      password: 'password',
      password_confirmation: 'password',
      first_name: FFaker::Name.first_name,
      last_name: FFaker::Name.last_name
    }
  end

  context 'when params are valid' do
    it 'returns auth tokens' do
      graphql_post(
        query: user_signup_mutation,
        variables: variables
      )

      expect(response).to match_schema(User::SignUpSchema::Success)
      expect(response.status).to be(200)
    end
  end

  context 'when email is not unique' do
    let!(:user_account) { create(:user_account) }

    it 'returns error data' do
      graphql_post(
        query: user_signup_mutation,
        variables: variables(email: "  #{user_account.email}")
      )

      expect(response).to match_schema(ErrorSchema)
      expect(response.status).to be(200)
    end
  end

  def variables(attributes = {})
    { input: default_variables.merge(attributes) }
  end
end
```

--

## We use a graphql_post helper to normalize the variables for GraphQL

`spec/support/graphql/request_helpers.rb`

```ruby
module GraphQL
  module RequestHelpers
    include ActionDispatch::Integration::RequestHelpers

    def graphql_post(query:, variables: {}, headers: nil, **kwargs)
      post(
        '/graphql',
        params: {
          query: query,
          variables: normalize_hash(variables).to_json
        },
        headers: headers,
        **kwargs
      )
    end

    private

    def normalize_hash(hash)
      raise unless hash.is_a?(Hash)

      hash = convert_decimal_values(hash)

      camelize_hash_keys(hash)
    end

    def convert_decimal_values(hash)
      # decimals are converted to string after converting to json
      # need to convert decimals to floats
      hash.transform_values do |value|
        next convert_decimal_values(value) if value.is_a?(::Hash)

        value.is_a?(::BigDecimal) ? value.to_f : value
      end
    end

    def camelize_hash_keys(hash)
      hash.deep_transform_keys { |key| key.to_s.camelize(:lower) }
    end
  end
end

```

--

## GraphQL queries for tests are defined like this

`spec/support/graphql/mutations_helpers/user.rb`
```ruby
module GraphQL
  module MutationsHelper
    def user_signup_mutation
      %(
        mutation userSignUp($input: UserSignUpInput!) {
          userSignUp(input: $input) {
            access
            csrf
            refresh
          }
        }
      )
    end
  end
end
```

--

## Let's run the test and see why it's failing

```ruby
{
  "errors"=>[
    {
      "message"=>"UserSignUpInput isn't a defined input type (on $input)",
      "locations"=>[{"line"=>2, "column"=>29}],
      "path"=>["mutation userSignUp"],
      "extensions"=> {
        "code"=>"variableRequiresValidType",
        "typeName"=>"UserSignUpInput",
        "variableName"=>"input"
      }
    },
    {
      "message"=>"Field 'userSignUp' doesn't exist on type 'Mutation'",
      "locations"=>[{"line"=>3, "column"=>11}],
      "path"=>["mutation userSignUp", "userSignUp"],
      "extensions"=>{
        "code"=>"undefinedField",
        "typeName"=>"Mutation",
        "fieldName"=>"userSignUp"}
      },
    {
      "message"=>"Variable $input is declared by userSignUp but not used",
      "locations"=>[{"line"=>2, "column"=>9}],
      "path"=>["mutation userSignUp"],
      "extensions"=>{"code"=>"variableNotUsed", "variableName"=>"input"}
    }
  ]
}
```

--

## Let's create a userSignUp mutation

`app/graphql/types/mutation_type.rb`
```ruby
module Types
  class MutationType < Types::Base::Object
    field :user_sign_up, mutation: Mutations::User::SignUp
  end
end
```
`app/graphql/mutations/user/sign_up.rb`
```ruby
module Mutations
  module User
    class SignUp < BaseMutation
      type Types::AuthTokenType

      description I18n.t('graphql.mutations.user.sign_up.desc')

      argument :input, Types::Inputs::UserSignUpInput, required: true

      def resolve(input:)
        match_operation UserAuth::Operation::SignUp.call(
          params: input.to_h,
          current_order: current_order,
          'contract.default.class' => UserAuth::Contract::SignUp
        )
      end
    end
  end
end
```

--

## The base mutation contains shared logic for all mutations

`app/graphql/mutations/base_mutation.rb`
```ruby
module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    private

    def match_operation(operation_result)
      MatchOperationResult.new.call(
        operation_result: operation_result,
        context: context
      )
    end

    def current_user
      context[:current_user]
    end
  end
end
```

--

## Let's create a UserSignUpInput type

`app/graphql/types/inputs/user_sign_up_input.rb`
```ruby
module Types
  module Inputs
    class UserSignUpInput < ::Types::Base::InputObject
      I18N_PATH = 'graphql.inputs.user_sign_up_input'

      graphql_name 'UserSignUpInput'

      description I18n.t("#{I18N_PATH}.desc")

      argument :first_name,
               String,
               required: true,
               description: I18n.t("#{I18N_PATH}.args.first_name"),
               prepare: ->(first_name, _ctx) { first_name.strip }

      argument :last_name,
               String,
               required: true,
               description: I18n.t("#{I18N_PATH}.args.last_name"),
               prepare: ->(last_name, _ctx) { last_name.strip }

      argument :email,
               String,
               required: true,
               description: I18n.t("#{I18N_PATH}.args.email"),
               prepare: ->(email, _ctx) { email.strip }

      argument :password,
               String,
               required: true,
               description: I18n.t("#{I18N_PATH}.args.password")

      argument :password_confirmation,
               String,
               required: true,
               description: I18n.t("#{I18N_PATH}.args.password_confirmation")
    end
  end
end
```

--

## Let's create AuthTokenType that will be returned as a result of userSignUp mutation

`app/graphql/types/auth_token_type.rb`
```ruby
module Types
  class AuthTokenType < Base::Object
    graphql_name 'AuthTokenType'
    description I18n.t('graphql.types.auth_token.desc')

    field :csrf,
          String,
          null: false,
          description: I18n.t('graphql.types.auth_token.fields.csrf')

    field :access,
          String,
          null: false,
          description: I18n.t('graphql.types.auth_token.fields.access')

    field :refresh,
          String,
          null: false,
          description: I18n.t('graphql.types.auth_token.fields.refresh')
  end
end
```
--

## Now the tests pass. Let's look at what will be returned to the client
#### The `resolve` method of `Mutations::User::SignUp` mutation returns an object:
```ruby
{
  :csrf=>"ygUDZ...2ohA==",
  :access=>"eyJhb...cQw",
  :access_expires_at=>2020-01-29 18:15:33 +0200,
  :refresh=>"eyJhb...dLrIQ",
  :refresh_expires_at=>2020-01-30 17:15:33 +0200
}
```
#### The above object will be mapped to the `Types::AuthTokenType` and the client will get the following data:
```ruby
{
  "data" => {
    "userSignUp" => { "access" => "eyJhb...cQw", "csrf" => "ygUDZ...2ohA==", "refresh" => "eyJhb...dLrIQ" }
  }
}
```
--

## Let's implement some queries

--

## Here is a request test for a query with pagination - `moviesSearch`

`spec/requests/graphql/queries/movies_search_spec.rb`
```ruby
describe 'query moviesSearch', type: :request do
  let(:movies) { create_list(:movie, 2, with_movie_images: true, with_poster: true) }

  before { movies }

  context 'when signed in user' do
    let(:user_account) { create :user_account }
    let(:payload) { { account_id: user_account.id } }
    let(:auth_token) do
      JWTSessions::Session.new(payload: payload).login[:access]
    end

    it 'responds with correct schema' do
      graphql_post(
        query: movies_search_query,
        variables: {},
        headers: { 'Authorization': "Bearer #{auth_token}" }
      )

      expect(response).to match_schema(Movies::IndexSchema)
      expect(response.status).to be(200)
    end
  end

  context 'when guest user' do
    it 'responds with error data' do
      graphql_post(
        query: movies_search_query,
        variables: {}
      )

      expect(response).to match_schema(UnauthenticatedErrorSchema)
      expect(response.status).to be(200)
    end
  end
end
```

--

## A moviesSearch query looks like this:

`spec/support/graphql/query_helpers/movie.rb`
```ruby
# frozen_string_literal: true

module GraphQL
  module QueryHelpers
    def movies_search_query
      %(
        query moviesSearch(
          $after: String
          $before: String
          $first: Int
          $last: Int
        ) {
          moviesSearch(
            after: $after
            before: $before
            first: $first
            last: $last
          ) {
            totalCount
            pageInfo {
              endCursor
              hasNextPage
              hasPreviousPage
              startCursor
            }
            edges {
              cursor
              node {
                id
                title
                originalTitle
                overview
                revenue
                budget
                runtime
                originalLanguage
                poster {
                  filePath
                }
                images {
                  filePath
                }
              }
            }
          }
        }
      )
    end
  end
end
```

--

## Let's add a movies_search to query type

`app/graphql/types/query_type.rb`
```ruby
module Types
  class QueryType < Types::Base::Object
    field :movies_search,
          resolver: Resolvers::MoviesSearch,
          connection: true,
          description: I18n.t('graphql.queries.movies_search')
  end
end
```

--

## Let's add a movies_search resolver

`app/graphql/resolvers/movies_search.rb`
```ruby
module Resolvers
  class MoviesSearch < AuthBase
    type Types::Connections::MovieConnection, null: false

    def resolve
      match_operation ::Movie::Operation::Index.call
    end
  end
end
```

--

## Let's add the connection and edge types for the movie

`app/graphql/types/connections/movie_connection.rb`
```ruby
module Types::Connections
  class MovieConnection < Types::Base::Connection
    edge_type Types::Edges::MovieEdge

    graphql_name 'MovieConnectionType'
  end
end
```

`app/graphql/types/edges/movie_edge.rb`
```ruby
module Types::Edges
  class MovieEdge < Types::Base::Edge
    node_type Types::MovieType

    graphql_name 'MovieEdgeType'
  end
end
```

--

## Let's declare a movie type

`app/graphql/types/movie_type.rb`
```ruby
module Types
  class MovieType < Base::Object
    I18N_PATH = 'graphql.types.movie_type'

    graphql_name 'MovieType'
    implements Types::Interfaces::NodeInterface
    description I18n.t("#{I18N_PATH}.desc")

    field :title, String, null: false, description: I18n.t("#{I18N_PATH}.fields.title")
    field :original_title, String, null: true, description: I18n.t("#{I18N_PATH}.fields.original_title")
    field :overview, String, null: true, description: I18n.t("#{I18N_PATH}.fields.overview")
    field :revenue, Integer, null: true, description: I18n.t("#{I18N_PATH}.fields.revenue")
    field :budget, Integer, null: true, description: I18n.t("#{I18N_PATH}.fields.budget")
    field :runtime, Integer, null: true, description: I18n.t("#{I18N_PATH}.fields.runtime")
    field :original_language, String, null: true, description: I18n.t("#{I18N_PATH}.fields.original_language")

    field :images,
          [Types::MovieImageType],
          null: true,
          description: I18n.t("#{I18N_PATH}.fields.images")

    field :poster,
          Types::PosterType,
          null: true,
          description: I18n.t("#{I18N_PATH}.fields.poster")

    def images
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |movie_ids, loader|
        ::MovieImage
          .with_attached_file
          .where(movie_id: movie_ids)
          .each do |movie_image|
            loader.call(movie_image.movie_id) { |memo| memo << movie_image.file }
          end
      end
    end

    def poster
      BatchLoader::GraphQL.for(object.id).batch do |record_ids, loader|
        ::ActiveStorage::Attachment.includes(:blob).where(
          record_id: record_ids,
          record_type: 'Movie'
        ).each do |attachment|
          loader.call(attachment.record_id, attachment)
        end
      end
    end
  end
end
```

--

## Let's define a node interface:

`app/graphql/types/interfaces/node_interface.rb`
```ruby
module Types::Interfaces::NodeInterface
  include Types::Base::Interface

  graphql_name 'NodeInterface'

  description I18n.t('graphql.interfaces.node.desc')

  field :id, ID, null: false, description: I18n.t('graphql.interfaces.node.fields.id')
end
```

--

## Let's define the movie_image and poster types:

`app/graphql/types/movie_image_type.rb`
```ruby
module Types
  class MovieImageType < Base::Object
    implements Types::Interfaces::ImageInterface

    graphql_name 'MovieImageType'

    I18N_PATH = 'graphql.types.movie_image_type'

    description I18n.t("#{I18N_PATH}.desc")
  end
end
```

`app/graphql/types/poster_type.rb`
```ruby
module Types
  class PosterType < Base::Object
    implements Types::Interfaces::ImageInterface

    graphql_name 'PosterType'

    I18N_PATH = 'graphql.types.poster_type'

    description I18n.t("#{I18N_PATH}.desc")
  end
end
```

--

## Let's add an image interface:

`app/graphql/types/interfaces/image_interface.rb`
```ruby
module Types::Interfaces::ImageInterface
  include Types::Base::Interface

  graphql_name 'ImageInterface'

  I18N_PATH = 'graphql.interfaces.image_interface'

  description I18n.t("#{I18N_PATH}.desc")

  field :file_path, String, null: true, description: I18n.t("#{I18N_PATH}.fields.file_path")

  def file_path
    return nil unless object.blob

    Rails.application.routes.url_helpers.rails_blob_url(object.blob)
  end
end
```

--

## Now let's add a `movie` query to fetch a movie by id

--

## Here is a request test for the query

`spec/requests/graphql/queries/movie_spec.rb`
```ruby
describe 'query movie', type: :request do
  let(:movie) { create(:movie, with_movie_images: true, with_poster: true) }

  before { movie }

  context 'when signed in user' do
    let(:user_account) { create :user_account }
    let(:payload) { { account_id: user_account.id } }
    let(:auth_token) do
      JWTSessions::Session.new(payload: payload).login[:access]
    end

    context 'when movie with specified id exists' do
      it 'responds with correct schema' do
        graphql_post(
          query: movie_query,
          variables: variables,
          headers: { 'Authorization': "Bearer #{auth_token}" }
        )

        expect(response).to match_schema(Movies::ShowSchema)
        expect(response.status).to be(200)
      end
    end

    context 'when movie with specified id does NOT exist' do
      it 'responds with correct schema' do
        graphql_post(
          query: movie_query,
          variables: variables(id: Movie.last.id + 1),
          headers: { 'Authorization': "Bearer #{auth_token}" }
        )

        expect(response).to match_schema(NotFoundSchema)
        expect(response.status).to be(200)
      end
    end
  end

  context 'when guest user' do
    it 'responds with error data' do
      graphql_post(
        query: movie_query,
        variables: variables
      )

      expect(response).to match_schema(UnauthenticatedErrorSchema)
      expect(response.status).to be(200)
    end
  end

  def variables(id: movie.id)
    { id: id }
  end
end
```

--

## A movies query looks like this:

`spec/support/graphql/query_helpers/movie.rb`
```ruby
# frozen_string_literal: true

module GraphQL
  module QueryHelpers
    def movie_query
      %(
        query movie($id: ID!) {
          movie(id: $id) {
            id
            title
            originalTitle
            overview
            revenue
            budget
            runtime
            originalLanguage
            poster {
              filePath
            }
            images {
              filePath
            }
          }
        }
      )
    end
  end
end
```

--

## Let's add a movie to query type

`app/graphql/types/query_type.rb`
```ruby
module Types
  class QueryType < Types::Base::Object
    field :movies_search,
          resolver: Resolvers::MoviesSearch,
          connection: true,
          description: I18n.t('graphql.queries.movies_search')

    field :movie,
          resolver: Resolvers::Movie,
          connection: false,
          description: I18n.t('graphql.queries.movie')
  end
end
```

--

## We already have a movie type defined. So, the only think we need to do is to add a resolver:

`app/graphql/resolvers/movie.rb`
```ruby
module Resolvers
  class Movie < AuthBase
    type Types::MovieType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      match_operation ::Movie::Operation::Show.call(params: { id: id })
    end
  end
end
```

---

## Usefull links

https://www.howtographql.com/ - good graphql guides - different languages, frontend/backend

http://graphql.org/ - official graphql docs

http://graphql-ruby.org/ - graphql-ruby gem docs

https://github.com/Shopify/graphql-design-tutorial/blob/master/TUTORIAL.md - GraphQL API design tutorial

https://engineering.universe.com/batching-a-powerful-way-to-solve-n-1-queries-every-rubyist-should-know-24e20c6e7b94 - batching with `batch-loader` gem

---

## The end
