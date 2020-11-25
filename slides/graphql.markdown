---
layout: slide
title:  GraphQL
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

- It enables declarative data fetching where a client can specify exactly what data it needs

- GraphQL is a query language for APIs - not databases. It’s database agnostic

---

# Advantages of GraphQL

---

## No more Over- and Underfetching

### One of the most common problems with REST is that of over- and underfetching. This happens because the only way for a client to fetch data is by hitting endpoints that return fixed data structures.

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
  # POST /graphql
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

### Thanks to the flexible nature of GraphQL, changes on the client-side can be made without any extra work on the server.
<p/>
### Thanks to strong type system, frontend engineers can mock the server and work before backend is ready.

---

## Less boilerplate work on the backend comparing with REST

`POST /graphql`

### Only ONE route is required for the GraphQL server

```ruby
  # app/controllers/graphql_controller.rb
  class GraphQLController < ApplicationController
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

## Auto-generated documentation

### GraphQL keeps documentation in sync with API changes.
### As the GraphQL API is tightly coupled with code, once a field, type or query changes, so do the docs.

---

## Convenient IDEs

--

### GraphiQL is the most popular IDE that helps you to test your GraphQL queries.

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

## Use cases of GraphQL

--

### 1. GraphQL server **with a connected database**

This architecture will be the most common for new projects. In the setup, you have a single database and a single (web) server that implements the GraphQL specification.

![](/assets/images/graphql/graphql_with_connected_db.png)

--

### 2. GraphQL server that is a ** thin layer in front of a number of third party or legacy systems**

GraphQL is used to **unify** these existing systems and hide their complexity. This way, new client applications can be developed that simply talk to the GraphQL server to fetch the data they need.

![](/assets/images/graphql/graphql_layer.png)

--

### 3. Hybrid approach

When a query is received by the server, it will resolve it and either retrieve the required data from the connected database or some of the integrated APIs

![](/assets/images/graphql/graphql_hybrid.png)

---

## Schema & Type System

### This schema serves as the contract between the client and the server to define how a client can access the data.
<p/>
### All the types that are exposed in an API are written down in a **schema** using the GraphQL Schema Definition Language (SDL).
<p/>
### You can create a GraphQL schema with any programming language.
<p/>

--

### The schema defines what queries are allowed to be made, what types of data can be fetched, and the relationships between these types.

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

## Queries and Mutations

---

### Queries

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

## Types, fields and arguments

---

### Types

#### Types describes data units in the system. There are such types as:

- Default scalar types
- Object types
- Custom scalar types
- Enum types
- Interface types
- Input types
- Union types

--

### Default scalar types

- String, like a JSON or Ruby string
- Int, like a JSON or Ruby integer
- Float, like a JSON or Ruby floating point decimal
- Boolean, like a JSON or Ruby boolean (true or false)
- ID, which a specialized String for representing unique object identifiers
- ISO8601DateTime, an ISO 8601-encoded datetime
- ISO8601Date, an ISO 8601-encoded date
- JSON, ⚠ This returns arbitrary JSON (Ruby hashes, arrays, strings, integers, floats, booleans and nils). Take care: by using this type, you completely lose all GraphQL type safety. Consider building object types for your data instead.
--

### Object types

#### The most basic components of a GraphQL schema are object types, which just represent a kind of object you can fetch from your service, and what fields it has.

#### Ruby example:
```ruby
module Types
  class Product < Base::Object
    field :id, ID, null: false
    field :name, String, null: false
    field :price, Types::Scalars::MoneyType, null: false
    field :inventory, Int, null: false

    def inventory
      # inventory is your custom field, you can return anything
    end
  end
end
```

#### GraphQL schema example:
```graphql
type Product {
  id: ID!
  name: String!
  price: Float!
  inventory: Int!
}
```

--

### Object Fields

#### Object fields expose data about that object or connect the object to other objects. Objects and Interfaces have fields.

```ruby
field :name, String, "The unique name of this list", null: false
```

By default, fields return values by:
- Trying to call a **method** on the underlying object
OR
- If the underlying object is a Hash, lookup a **key** in that hash

--

#### You can override the method name with the **method**: keyword, or override the hash key with the **hash_key**: keyword, for example:
```ruby
# Use the `#best_score` method to resolve this field
field :top_score, Integer, null: false, method: :best_score

# Lookup `hash["allPlayers"]` to resolve this field
field :players, [User], null: false, hash_key: "allPlayers"
```
#### If you don’t want to delegate to the underlying object, you can define a method for each field:

```ruby
# Use the custom method below to resolve this field
field :total_games_played, Integer, null: false

def total_games_played
  object.games.count
end
```
--

### Field arguments

Arguments allow fields to take input to their resolution. For example:

- A search() field may take a term: argument, which is the query to use for searching
<p/>`search(term: "GraphQL")`
- A user() field may take an id: argument, which specifies which user to find
<p/>`user(id: 1)`
- An attachments() field may take a type: argument, which filters the result by file type
<p/>`attachments(type: PHOTO)`

```ruby
field :total_games_played, Integer, null: false do
  argument :starting_from, Date, required: false, default_value: false
end

def total_games_played(starting_from:)
  # Business logic goes here
end
```
--

### Resolvers

A GraphQL::Schema::Resolver is a container for field signature and resolution logic. It can be attached to a field with the **resolver:** keyword:
```ruby
field :recommended_items, resolver: Resolvers::RecommendedItems
```

```ruby
module Resolvers
  class RecommendedItems < Resolvers::Base
    type [Types::Item], null: false

    argument :order_by, Types::ItemOrder, required: false
    argument :category, Types::ItemCategory, required: false

    def resolve(order_by: nil, category: nil)
      # call your application logic here:
      recommendations = ItemRecommendation.new(
        viewer: context[:viewer],
        recommended_for: object,
        order_by: order_by,
        category: category,
      )
      # return the list of items
      recommendations.items
    end
  end
end
```

--

Putting logic in a Resolver has some downsides:

- Since it’s coupled to GraphQL, it’s **harder to test** than a plain ol’ Ruby object in your app
- Since the base class comes from GraphQL-Ruby, it’s **subject to upstream changes** which may require updates in your code

You can put display logic (sorting, filtering, etc.) into a plain ol’ Ruby class in your app, and test that class:

```ruby
field :recommended_items, [Types::Item], null: false

def recommended_items
  ItemRecommendation.new(user: context[:viewer]).items
end
```

--

### Custom scalar types

#### There is also a way to specify custom scalar types. For example, we could define a Money type:

```ruby
module Types::Scalars
  class MoneyType < Types::Base::Scalar
    description 'A monetary value number'

    def self.coerce_input(input_value, _context)
      # Store money as integer
      return input_value * 100 if input_value.is_a?(Numeric)

      raise GraphQL::CoercionError, "#{input_value.inspect} is not a valid number"
    end

    def self.coerce_result(ruby_value, _context)
      # Return money as a number with floating point
      ruby_value / 100.0
    end
  end
end
```

```graphql
"""
A monetary value number
"""
scalar Money

type Product {
  ...
  price: Money
}
```

--

### Enum types

#### Enumeration types are a special kind of scalar that is restricted to a particular set of allowed values:
```ruby
class Types::Enums::DateRangeEnum < ::Types::Base::Enum
  description 'Date ranges for filtering'

  value 'TODAY' do
    value Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
    description 'Filter records that were created/placed/etc today'
  end

  value 'LAST_7_DAYS' do
    value((Time.zone.today - 7.days).beginning_of_day..Time.zone.today.end_of_day)
    description 'Filter records that were created/placed/etc in the date range between 7 days ago and today'
  end
end

class Types::Inputs::ProductsFilterInput < ::Types::Base::InputObject
  argument :date_range, Types::Inputs::DateRangeEnum, required: false, description: 'Date filter'
end
```

```graphql
"""
Date ranges for filtering
"""
enum DateRangeEnum {
  """
  Filter records that were created/placed/etc in the date range between 7 days ago and today
  """
  LAST_7_DAYS
  """
  Filter records that were created/placed/etc today
  """
  TODAY
}
```

--

### Interface types

#### Interfaces are lists of fields which may be implemented by object types. Interfaces may also provide field implementations along with the signatures.

```ruby
module Types::Interfaces::Node
  include Types::Base::Interface

  graphql_name 'Node'

  description 'An object with an ID to support global identification'

  field :id, ID, null: false, description: 'Globally unique identifier'

  # def id # Optional: provide a special implementation of `id` here
  #   ...
  # end
end
```
#### Interface usage example:

```ruby
class Types::ProductType < Base::Object
  graphql_name 'ProductType'

  implements Types::Interfaces::Node

  description 'Product'

  field :name, String, null: false, description: "Product's title"
end
```

--

```graphql
"""
An object with an ID to support global identification.
"""
interface Node {
  """
  Globally unique identifier.
  """
  id: ID!
}

"""
Product
"""
type ProductType implements Node {
  """
  ID
  """
  id: ID!
  """
  Product's title
  """
  title: String!
}
```

--

### Input types

Input objects have arguments which are identical to Field arguments.

```ruby
class Types::Inputs::ProductCreateInput < ::Types::Base::InputObject
  graphql_name 'ProductCreateInput'

  description 'Input for product creation'

  argument :title, String, required: true,
                           description: 'product title',
                           prepare: ->(title, _ctx) { title.strip }

  argument :slug, String, required: true,
                          description: 'product slug',
                          prepare: ->(slug, _ctx) { slug.strip }
end

```

```ruby
class Mutations::Product::Create < Mutations::BaseMutation
  ...

  argument :input, Types::Inputs::ProductCreateInput, required: true

  def resolve(input:)
    # do something with data input
  end
end

```

--

### Union types

A Union is is a collection of object types which may appear in the same place.

The members of a union are declared with **possible types** .

A union itself has no fields; only its members have fields. So, when you query, you must use fragment spreads to access fields.

```ruby
class Types::Movie < Types::BaseObject
  field :id, ID, null: false
  field :title, String, null: false
  field :director, String, null: false
end

class Types::Book < Types::BaseObject
  field :id, ID, null: false
  field :title, String, null: false
end

class SearchResultUnionType < Types::BaseUnion
  description 'Represents either a Movie, Book or Album'

  possible_types Book, Movie

  def self.resolve_type(object, _context)
    case object
    when Movie then Types::Movie
    when Book then Types::Book
    else
      raise "Unknown search result type"
    end
  end
end

```

--

### Non-Null Types

GraphQL’s concept of non-null is expressed in the SDL with !, for example:

```graphql
type User {
  # This field _always_ returns a String, never returns `null`
  name: String!
  # `since:` _must_ be passed a `DateTime` value, it can never be omitted or passed `null`
  followers(since: DateTime!): [User!]!
}
```

#### Non-null return types
```ruby
# equivalent to `name: String!` above
field :name, String, null: false
```

#### Non-null argument types
```ruby
# equivalent to `since: DateTime!` above
argument :since, Types::DateTime, required: true
```

--

### Lists

GraphQL has list types which are ordered lists containing items of other types. The following examples use the SDL:
```graphql
type BlogPost {
  # Post tags
  tags: [String!]
}

type Query {
  # Return posts list
  posts: [BlogPost!]
}
```

```ruby
# A field returning a list type:
# Equivalent to `tags: [String!]` above
field :tags, [String], null: true
```

--

### Lists Nullability

- Nullability of the field: can this field **return null**, or does it always return a list?
- Nullability of the list items: when a list is present, may it **include null**?

#### Non-null lists with non-null items
```ruby
field :tags, [String], null: false
# In GraphQL, tags: [String!]!
# Valid values: [], [1, 2]
```
#### Non-null lists with nullable items
```ruby
field :tags, [String, null: true], null: false
# In GraphQL, tags: [String]!
# Valid values: [], [1, 2], [null], [1, null]
```
#### Nullable lists with nullable items
```ruby
field :tags, [String, null: true], null: true
# In GraphQL, tags: [String]
# Valid values: [], [1, 2], [null], [1, null], null
```
#### Nullable lists with non-null items
```ruby
field :tags, [String], null: true
# In GraphQL, tags: [String!]
# Valid values: [], [1, 2], null
```

---

## Solving the N+1 Problem

--

### GraphQL allows you to create highly flexible APIs where it is possible to write queries to request any combination of data.
### The downside is, as the details of any query are unpredictable, it is more complicated to avoid N+1 queries.

--

## Example

Imagine we have an app cataloguing museums and their exhibits, with a GraphQL API setup for querying them. Our basic museum type might look a little like this:

```ruby
# app/graphql/types/museum_type.rb

module Types
  class MuseumType < GraphQL::Schema::Object
    field :name, String, null: false
    field :exhibits, [ExhibitType], null: false
  end
end
```
And our exhibit type:

```ruby
# app/graphql/types/exhibit_type.rb

module Types
  class ExhibitType < GraphQL::Schema::Object
    field :name, String, null: false
  end
end
```
--
And also our root query type (note for this example we are only declaring a root query for museums, not exhibits):
```ruby
# app/graphql/types/query_type.rb

module Types
  class QueryType < GraphQL::Schema::Object
    field :museums, [MuseumType], null: false

    def museums
      Museum.all
    end
  end
end
```

Say we now want to run a query retrieving all of our museums and the name of each of their exhibits. Executing the following GraphQL query in our GraphiQL editor:
```ruby
{
  museums {
    name
    exhibits {
      name
    }
  }
}
```

--

And the result would be:

![](/assets/images/graphql/lazy_loading.png)
--

## Solutions

<br/>

### gem 'graphql-batch'
- Used by Shopify
- Depends on promise.rb gem

<br/>

### gem 'batch-loader'
- Used by GitLab and Netflix
- 0 dependencies. Uses lazy objects instead of Promises

--

To deal with we need to make some changes:

```ruby
# app/graphql/types/museum_type.rb

module Types
  class MuseumType < GraphQL::Schema::Object
    field :name, String, null: false

    field :exhibits, [ExhibitType], null: true

    def exhibits
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |museum_ids, loader|
        Exhibit.where(museum_id: museum_ids).each do |exhibit|
          loader.call(exhibit.museum_id) { |memo| memo << exhibit }
        end
      end
    end
  end
end
```
And also in our schema we need to make the following change:

```ruby
# app/graphql/app_schema.rb

class AppSchema < GraphQL::Schema
  query(Types::QueryType)

  # enable batch loading
  use BatchLoader::GraphQL
end
```
--

#### Run the same query again:
```ruby
{
  museums {
    name
    exhibits {
      name
    }
  }
}
```
#### And the result would be:

![](/assets/images/graphql/without_lazy_loading.png)

#### BatchLoader is evaluated lazily, which means rather than the exhibits being loaded from the database instantly for each museum, the necessary museum IDs are stored and then executed in a single call to Exhibit.where, eliminating the N+1.
#### BatchLoader will also cache the result of this query, so subsequent requests will be even faster as the database won't get hit at all.

---

## Error Handling

--

### Schema validation errors

#### Because GraphQL is strongly typed, it performs **validation of all queries before executing** them. If an incoming query is invalid, it isn’t executed. Instead, a response is sent back with "errors":

```graphql
  query {
    products {
      unknown
    }
  }
```

```json
  {
    "errors": [
      {
        "message": "Field 'unknown' doesn't exist on type 'Product'",
        "locations": [
          {
            "line": 3,
            "column": 5
          }
        ],
        "fields": [
          "query",
          "products",
          "unknown"
        ]
      }
    ]
  }
```

--

#### The response may include both "data" and "errors" in the case of a partial success:

```json
{
  "data" => { ... } # parts of the query that ran successfully
  "errors" => [ ... ] # errors that prevented some parts of the query from running
}
```

#### You can add errors to the array by raising GraphQL::ExecutionError

```ruby
raise GraphQL::ExecutionError, "Can't continue with this query"
```

```json
{
  "errors" => [
    {
      "message" => "Can't continue with this query",
      "locations" => [
        {
          "line" => 2,
          "column" => 10,
        }
      ],
      "path" => ["user", "login"],
    }
  ]
}
```

--

### Handling errors raised during field resolution

You can configure your schema to rescue errors using `graphql-errors` gem. Schema will handle errors before they propagate to the rails controller.

```ruby
class MySchema < GraphQL::Schema
  # Use the new error handling:
  use GraphQL::Execution::Errors

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    # Raise a graphql-friendly error with a custom message
    raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
  end
end
```

Inside the handler, you can:

- Raise a GraphQL-friendly GraphQL::ExecutionError to return to the user
- Re-raise the given err to crash the query and halt execution. (The error will propagate to your application, eg, the controller.)
- Log errors to Bugsnag or another tool

--

### Customizing errors

Override #to_h in a subclass of GraphQL::ExecutionError, for example:

```ruby
module GraphQL
  class AuthenticationError < ExecutionError
    def to_h
      super.merge('extensions' => { 'code' => 'UNAUTHENTICATED' })
    end
  end
end
```

Now, "extensions" => { "code" => "UNAUTHENTICATED" } will be added to the error JSON

---

## GraphQL limitations

### - File downloads
GraphQL uses JSON format, which represents as text format, not as binary.
You can send a file as base64 string or send a download link.

### - Incoming Webhooks
You will need to add the REST endpoints to listen for events from services like Stripe.

---

## Let's start creating an application

---

## Setup GraphQL server using Ruby on Rails

Add to Gemfile

```ruby
  gem 'graphql'
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

#### GraphQL Schema
```ruby
  # app/graphql/graphql_meetup_schema.rb
  class GraphQLMeetupSchema < GraphQL::Schema
    mutation(Types::MutationType)
    query(Types::QueryType)
  end
```

#### GraphQL base types
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

      result = GraphQLMeetupSchema.execute(
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

## Cursor Based Pagination

--

#### Connections are a pagination solution which started with Relay JS, but now it’s used for almost any GraphQL API.

#### Connections has a structure:

```
Connection -> Edge -> Node
```

```graphql
query {
  products(first: 2) {
    # Connection
    totalCount
    pageInfo {
      endCursor
      hasNextPage
      hasPreviousPage
      startCursor
    }
    edges {
      # Edge
      node {
        # Node
        id
        name
        description
        quantity
      }
      cursor
    }
  }
}
```

--

#### and we will receive

```json
{
  "data": {
    "products": {
      "totalCount": 5,
      "pageInfo": {
        "endCursor": "Mg", "hasNextPage": true, "hasPreviousPage": false, "startCursor": "MQ"
      },
      "edges": [{
          "node": {
            "id": "5659e44e-bc22-4e62-933d-4417a9d1d1bc",
            "name": "First product",
            "description": "First product description",
            "quantity": 12
          },
          "cursor": "MQ"
        },
        {
          "node": {
            "id": "c2b2cbb4-a6f3-4b03-925a-fe9b9a73fa56",
            "name": "Second product",
            "description": "Second product description",
            "quantity": 2
          },
          "cursor": "Mg"
        }
      ]
    }
  }
}
```

--

### Connection
#### Expose **pagination-related metadata** and access to the items

### Edge
#### Expose **node** and **cursor** fields

### Node
#### Nodes are items in a list. A node is usually an object in your schema.

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

## Repo with application

https://github.com/rubygarage/graphql_meetup

---

## Useful links

https://www.howtographql.com/ - good graphql guides - different languages, frontend/backend

http://graphql.org/ - official graphql docs

http://graphql-ruby.org/ - graphql-ruby gem docs

https://github.com/Shopify/graphql-design-tutorial/blob/master/TUTORIAL.md - GraphQL API design tutorial

https://engineering.universe.com/batching-a-powerful-way-to-solve-n-1-queries-every-rubyist-should-know-24e20c6e7b94 - batching with `batch-loader` gem

https://blog.apollographql.com/designing-graphql-mutations-e09de826ed97 - designing graphql mutations

https://relay.dev/graphql/connections.htm - GraphQL Cursor Connections Specification

---

# The end

## Questions?
