---
layout: slide
title:  API
---

# RESTApi with Rails

---

# API

![](/rubygarage/assets/images/api/rest-api-langs.png)

RESTful Web services are one way of providing interoperability between computer systems on the Internet. REST-compliant Web services allow requesting systems to access and manipulate textual representations of Web resources using a uniform and predefined set of stateless operations. Other forms of Web service exist, which expose their own arbitrary sets of operations such as WSDL and SOAP. "Web resources" were first defined on the World Wide Web as documents or files identified by their URLs, but today they have a much more generic and abstract definition encompassing every thing or entity that can be identified, named, addressed or handled, in any way whatsoever, on the Web. In a RESTful Web service, requests made to a resource's URI will elicit a response that may be in XML, HTML, JSON or some other defined format.

--

## Do You Need an API?

1. Single Page Application
2. Satellite applications (iOS, Android, Smart TV apps, etc...)
3. Provide public/private services
4. Microservices or other architectural solutions

---

# Rails

Why use Rails for APIs?

The first question a lot of people have when thinking about building a JSON API using Rails is: "isn't using Rails to spit out some JSON overkill? Shouldn't I just use something like Sinatra?"

For very simple APIs, this may be true. However, even in very HTML-heavy applications, most of an application's logic is actually outside of the view layer.

The reason most people use Rails is that it provides a set of defaults that allows us to get up and running quickly without having to make a lot of trivial decisions.

Let's take a look at some of the things that Rails provides out of the box that are still applicable to API applications.

1. large community
2. scalability
3. batteries included
4. you already know it (or not?)

---

# Versioning

If you are writing a consistent API which will be consumed by multiple clients then it is the best practise to separate out the API under a namespace.

API versioning lets your API to be backwards compatible.

<br/>

http://stackoverflow.com/questions/389169/best-practices-for-api-versioning

--

# Routes

Move your API under a namespace `:api` and the `:version` in your `routes.rb`

```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :provider_sessions, only: [:create]
      end

      get :about, to: 'texts#about'
      get :terms_of_service, to: 'texts#terms_of_service'

      concern :reportable do
        resource :report, only: [:create]
      end

      resources :story_points, concerns: [:reportable], only: [:index, :show, :create, :update, :destroy] do
        resources :stories, only: [:index]
      end
    end
  end
end
```

--

## New API features?

So if you want to introduce a new API version with new features the all you need to do is generate it under `/:api/:new_version`.
(Something like `myawesomedomain/api/v2`)

This ensures the changes are applied only to the current version without affecting the old API.

```ruby
Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v2 do
      resources :users, only: [:create, :show]
      resources :posts, except: :destroy
      resources :videos
      resources :sessions
      resources :tags
      resources :favorites
    end
  end
end
```

--

# Controllers

app/controllers/api/v1/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class Api::V1::PostsController < ApplicationController
  respond_to :json

  def index
    @posts = Post.all

    render json: @posts
  end
end
```

app/controllers/api/v2/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class Api::V2::PostsController < ApplicationController
  respond_to :json

  def index
    @posts = Post.where('created_at >= ?', custom_time)

    render json: @posts
  end
end
```

--

# Api Controller

Additionally you can generate an API Controller that inherits from `ApplicationController`. Then you can check the API specific Logic like Http Header and Token verification without affecting the functionality of the App.

```ruby
class Api::V1::ApiController < ApplicationController
  #Add Api Specific methods and validation
end
```


```ruby
class Api::V1::PostsController < Api::V1::ApiController
  def index
    @posts = Post.all

    render json: @posts
  end
end
```

---

# Serializers

Serialization is the process of translating data structures or object state into a format that can be stored

Rails serializes the object passed into the required format. What if you want to customise the JSON output? Like Remove the root element, Add custom attributes or Adding `has_many` relations? How do you acheive this?

--

# jbuilder

Jbuilder gives you a simple DSL for declaring JSON structures that beats massaging giant hash structures.

controllers/api/v1/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class Api::V1::PostsController < Api::V1::ApiController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
```

--

views/api/v1/posts/index.json.jbuilder <!-- .element: class="filename" -->

```ruby
json.array!(@posts) do |post|
  json.extract! post, :id, :name, :post_url, :user_id
  json.url post_url(post, format: :json)
end
```

views/api/v1/posts/show.json.jbuilder <!-- .element: class="filename" -->

```ruby
json.extract! @post, :id, :name, :post_url, :user_id, :created_at, :updated_at
```

You can use partials as well

```ruby
json.array! @posts, partial: 'posts/post', as: :post
```

--

To Customise your attributes you can use the following:

```ruby
json.extract! @post, :id
json.set! :first_name, @post.name
json.extract! @post, :post_url, :user_id, :created_at, :updated_at
```

Which will produce the following

```json
{
  "id": 1,
  "first_name": "Sample",
  "post_url": "www.google.com",
  "user_id": 1,
  "created_at": "2014-05-22T14:07:20.235Z",
  "updated_at": "2014-05-22T14:07:20.235Z"
}
```

--

# ActiveModelSerializers

`ActiveModel::Serializers` encapsulates the JSON serialization of objects.
In short, serializers replace hash-driven development with object-oriented development.

```ruby
gem "active_model_serializers"
```

generating resource:
```bash
rails g resource comment content:text user:references post:references
```

--

When we try to render out a model in a JSON format active model serializers automatically look for a serializer with the same name which is used to fetch data.

So render `ruby json: Post.find(params[:id])` will automatically look for a serialzer named `PostSerializer`

```ruby
class PostSerializer < ActiveModel::Serializer
  #attributes for post
end
```

You can also specify a serializer while rendering json.

```ruby
render json: @post, serializer: MyAwesomeSerializer
```

--

## Customizing the format

Since Active Model Serailizers follow an object oriented approach customising the output is a piece of cake!

```ruby
class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :custom_created_at

  def custom_time
    object.created_at.strftime('%H:%M')
  end

  def name
   obj.name.capitalize
  end
end
```

--

## Customizing the root element

You can either disable the root element or specify one of your own. There are multiple ways to achieve this

```ruby
render json: @posts, root: false
```

```ruby
render json: @posts, root: 'custom_posts'
```

```ruby
class PostSerializer < ActiveModel::Serializer
  self.root = false
end
```

initializers/active_model.rb <!-- .element: class="filename" -->

```ruby
ActiveModel::Serializer.root = false
```

--

## Associations

Active Model Serializers works great with associations as well. You can specify `has_many` and `belongs_to` (which technically is `has_one` in this) in the serializer. This will automatically render the associated objects along with the current object.

```ruby
class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :url
  has_many :comments
  has_one :user
end
```

And it works great with polymorphic relations too.

```ruby
has_one :commentable, polymorphic: true
```

---

# Security

--

# Authentication

No cookies, but tokens...

Token based authentication is stateless. We are not storing any information about our user on the server or in a session.
JSON Web Tokens (JWT), pronounced “jot”, are a standard since the information they carry is transmitted via JSON.

--

# Devise Token Auth

Simple, secure token based authentication for Rails.
The same devise, but with tokens.

## Installation

```ruby
gem 'devise_token_auth'
```

```bash
bundle install
```

--

## Configuration

```bash
rails g devise_token_auth:install User auth
rake db:migrate
```

routes.rb <!-- .element: class="filename" -->

```ruby
mount_devise_token_auth_for 'User', at: 'auth'
```

--

# Token Header Format

The authentication information should be included by the client in the headers of each request. The headers follow the RFC 6750 Bearer Token format:

```ruby
'access-token': 'wwwww',
'token-type':   'Bearer',
'client':       'xxxxx',
'expiry':       'yyyyy',
'uid':          'zzzzz'
```

--

# CORS

What is it? Why should I use it?

CORS is Cross Origin Resource Sharing which is a W3C draft which specifies how the browser should communicate with the server when sharing resources across origins. Basically any request from other than the server is rejected with No 'Access-Control-Allow-Origin' header present error.

CORS checks for custom HTTP headers so that it can verify the request.

[More on CORS](http://www.nczonline.net/blog/2010/05/25/cross-domain-ajax-with-cross-origin-resource-sharing/)

Now if we access our API from a client application then the server cannot validate the origin of the request. It throws an error that HTTP header could not be found. So how to handle it?

--

### Rack CORS

[Github](https://github.com/cyu/rack-cors)

```ruby
gem 'rack-cors', require: 'rack/cors'
```

It's really easy to configure the gem as well. You just have to provide the whitelist domains to allow access to your resources. If your API is to be consumed by third parties then we can whitelist all domains * and then write our own authentication.

This Gem basically adds Rack::Cors to our Middleware that intercepts the requests and handles accordingly.

--

### `devise_token_auth` CORS example

config/application.rb <!-- .element: class="filename" -->

```ruby
module YourApp
  class Application < Rails::Application
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :post, :options, :delete, :put]
      end
    end
  end
end
```

---

# Docs

## describe the code, through the code

--

# Apipie

Apipie-rails is a DSL and Rails engine for documenting your RESTful API. Instead of traditional use of `#comments`, Apipie lets you describe the code, through the code. This brings advantages like:

<br/>

- No need to learn yet another syntax, you already know Ruby, right?
- Possibility of reusing the docs for other purposes (such as validation)
- Easier to extend and maintain (no string parsing involved)
- Possibility of reusing other sources for documentation purposes (such as routes etc.)

<br/>

The documentation is available from within your app (by default under the /apipie path.) In development mode, you can see the changes as you go. It's markup language agnostic, and even provides an API for reusing the documentation data in JSON.

--

# Getting started

The easiest way to get Apipie up and running with your app is:

```bash
echo "gem 'apipie-rails'" >> Gemfile
bundle install
rails g apipie:install
```

```ruby
api :GET, '/users/:id'
param :id, :number
def show
  # ...
end
```

Run your application and see the result at `http://localhost:3000/apipie`.

For further processing, you can use `http://localhost:3000/apipie.json`.

--

## Resource description

You can describe a resource on the controller level.

```ruby
resource_description do
  short 'Site members'
  formats ['json']
  param :id, Fixnum, desc: 'User ID', required: false
  param :resource_param, Hash, desc: 'Param description for all methods' do
    param :ausername, String, desc: 'Username for login', required: true
    param :apassword, String, desc: 'Password for login', required: true
  end
  api_version "development"
  error 404, "Missing"
  error 500, "Server crashed for some <%= reason %>", meta: { anything: 'you can think of' }
  meta author: { name: 'John', surname: 'Doe' }
  description <<-EOS
    == Long description
     Example resource for rest api documentation
     These can now be accessed in <tt>shared/header</tt> with:
       Headline: <%= headline %>
       First name: <%= person.first_name %>

     If you need to find out whether a certain local variable has been
     assigned a value in a particular render call, you need to use the
     following pattern:

     <% if local_assigns.has_key? :headline %>
        Headline: <%= headline %>
     <% end %>

    Testing using <tt>defined? headline</tt> will not work. This is an
    implementation restriction.

    === Template caching

    By default, Rails will compile each template to a method in order
    to render it. When you alter a template, Rails will check the
    file's modification time and recompile it in development mode.
  EOS
end
```

--

## Method description

Then describe methods available to your API.

```ruby
# The simplest case: just load the paths from routes.rb
api!
def index
end

# More complex example
api :GET, '/users/:id', 'Show user profile'
show false
error code: 401, desc: 'Unauthorized'
error code: 404, desc: 'Not Found', meta: { anything: 'you can think of' }
param :session, String, desc: 'user is logged in', required: true
param :regexp_param, /^[0-9]* years/, desc: 'regexp param'
param :array_param, [100, 'one', 'two', 1, 2], desc: 'array validator'
param :boolean_param, [true, false], desc: 'array validator with boolean'
param :proc_param, lambda { |val|
  val == 'param value' ? true : "The only good value is 'param value'."
}, desc: 'proc validator'
param :param_with_metadata, String, desc: '', meta: [:your, :custom, :metadata]
description 'method description'
formats ['json', 'jsonp', 'xml']
meta message: 'Some very important info'
example " 'user': {...} "
see 'users#showme', 'link description'
see link: 'users#update', desc: 'another link description'
def show
  #...
end
```

--

## Versioning

Every resource/method can belong to one or more versions. The version is specified with the `api_version` DSL keyword.
When not specified, the resource belongs to `config.default_version` ("1.0" by default)

```ruby
resource_description do
  api_versions '1', '2'
end

api :GET, '/api/users/', 'List: users'
api_version '1'
def index
  # ...
end

api :GET, '/api/users/', 'List: users', deprecated: true
```

--

## Examples Recording

You can also use the tests to generate up-to-date examples for your code.

Configure RSpec in this way:

```ruby
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run show_in_doc: true if ENV['APIPIE_RECORD']
end
```

--

```ruby
describe 'This is the correct path' do
  it 'some test', :show_in_doc do
    ....
  end
end

context 'These are edge cases' do
  it "Can't authenticate" do
    # ...
  end

  it 'record not found' do
    # ...
  end
end
```

[Docs Example](https://theforeman.org/api/1.14/index.html)

---

# Testing

### NO FEATURE TESTS!

--

## Request specs

Request specs provide a thin wrapper around Rails' integration tests, and are
designed to drive behavior through the full stack, including routing
(provided by Rails) and without stubbing (that's up to you).

spec/requests/widget_management_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'Widget management', type: :request do

  it "creates a Widget and redirects to the Widget's page" do
    get '/widgets/new'
    expect(response).to render_template(:new)

    post '/widgets', widget: { name: 'My Widget' }

    expect(response).to redirect_to(assigns(:widget))
    follow_redirect!

    expect(response).to render_template(:show)
    expect(response.body).to include('Widget was successfully created.')
  end

  it 'does not render a different template' do
    get '/widgets/new'
    expect(response).to_not render_template(:show)
  end
end
```

--

## Check responses

Validate the JSON returned by your Rails JSON APIs

```ruby
group :test do
  gem 'json_matchers'
end
```

Define your JSON Schema in the schema directory:

spec/support/api/schemas/posts.json <!-- .element: class="filename" -->

```json
{
  "type": "object",
  "required": ["posts"],
  "properties": {
    "posts": {
      "type": "array",
      "items":{
        "required": ["id", "title", "body"],
        "properties": {
          "id": { "type": "integer" },
          "title": { "type": "string" },
          "body": { "type": "string" }
        }
      }
    }
  }
}
```

--

Then, validate response against your schema with `match_response_schema`

spec/requests/posts_spec.rb <!-- .element: class="filename" -->

```ruby
describe 'GET /posts' do
  it 'returns Posts' do
    get posts_path, format: :json

    expect(response.status).to eq 200
    expect(response).to match_response_schema('posts')
  end
end
```

---

# Tools

* Gems
  * [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth)
  * [apipie-rails](https://github.com/Apipie/apipie-rails)
  * [json_matchers](https://github.com/thoughtbot/json_matchers)
  * [active_model_serializers](https://github.com/rails-api/active_model_serializers)
  * [rack-cors](https://github.com/cyu/rack-cors)

* Devise token auth clients
  * [ng-token-auth](https://github.com/lynndylanhurley/ng-token-auth)
  * [angular2-token](https://github.com/neroniaky/angular2-token)
  * [j-toker](https://github.com/lynndylanhurley/j-toker)

* API Clients
  * [Paw](https://paw.cloud/)
  * [Postman](https://www.getpostman.com)

---

# Thank You

---

# The End
