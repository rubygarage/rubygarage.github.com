---
layout: slide
title:  Routes
---

# Routes

> The Rails router recognizes URLs and dispatches them to a controller's action. It can also generate paths and URLs, avoiding the need to hardcode strings in your views.

<br>

[Go to Table of Contents](/)

---

## Routes

When your Rails application receives an incoming request for:

```output
GET /posts/17
```

it asks the router to match it to a controller action. If the first matching route is:

config/routes.rb <!-- .element: class="filename" -->

```ruby
get '/posts/:id', to: 'posts#show', as: 'post'
```
the request is dispatched to the posts controller's show action with { id: '17' } in params.

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
def show
  @post = Post.find(params[:id])
end
```

app/views/posts/show.html.erb <!-- .element: class="filename" -->

```html
<%= link_to 'Post Record', post_path(@post) %>
```

---

## CRUD, Verbs, and Actions

Resource routing allows you to quickly declare all of the common routes for a given resourceful controller. Instead of declaring separate routes for your index, show, new, edit, create, update and destroy actions, a resourceful route declares them in a single line of code.

config/routes.rb <!-- .element: class="filename" -->

```ruby
Community::Application.routes.draw do
  resources :posts
end
```

| Prefix    |                 Verb                | URI Pattern                                                                                        | Controller#Action                                                 |
|-----------|:-----------------------------------:|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| posts     | GET <br> POST                       |                               /posts(.:format) <br> /posts(.:format)                               | posts#index <br> posts#create                                     |
| new_post  |                 GET                 | /posts/new(.:format)                                                                               | posts#new                                                         |
| edit_post |                 GET                 | /posts/:id/edit(.:format)                                                                          | posts#edit                                                        |
| post      | GET <br> PATCH <br> PUT <br> DELETE | /posts/:id(.:format) <br> /posts/:id(.:format) <br> /posts/:id(.:format) <br> /posts/:id(.:format) | posts#show <br> posts#update <br> posts#update <br> posts#destroy |

--

```ruby
posts_path            # => '/posts'
posts_url             # => 'http://blog.dev/posts'
new_post_path         # => '/posts/new'
post_path(@post)      # => '/posts/1'
post_path(1)          # => '/posts/1'
edit_post_path(@post) # => '/posts/1/edit'
```

---

## Multiple Resources

```ruby
resources :users
resources :posts
resources :comments
```
or

```ruby
resources :users, :posts, :comments
```

---

## Singular Resources

```ruby
get 'user', to: 'users#show'
```

This resourceful route:

```ruby
resource :user
```

| Prefix    |                     Verb                     | URI Pattern                                                                                              | Controller#Action                                                         |
|-----------|:--------------------------------------------:|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| user      | POST                                         |                                              /user(.:format)                                             | users#create                                                              |
| new_user  |                      GET                     | /user/new(.:format)                                                                                      | users#new                                                                 |
| edit_user | GET <br> GET <br> PATCH <br> PUT <br> DELETE | /user/edit(.:format) <br> /user(.:format) <br> /user(.:format) <br> /user(.:format) <br> /user(.:format) | users#edit<br>users#show<br>users#update<br>users#update<br>users#destroy |

---

## Controller Namespaces and Routing

```ruby
namespace :admin do
  resources :posts
end
```

| Prefix          |              Verb             | URI Pattern                                                                                                                | Controller#Action                                                                         |
|-----------------|:-----------------------------:|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| admin_posts     | GET <br> POST                 |                                     /admin/posts(.:format) <br> /admin/posts(.:format)                                     | admin/posts#index <br> admin/posts#create                                                 |
| new_admin_post  |              GET              | /admin/posts/new(.:format)                                                                                                 | admin/posts#new                                                                           |
| edit_admin_post | GET                           | /admin/posts/:id/edit(.:format)                                                                                            | admin/posts#edit                                                                          |
| admin_post      | GET<br>PATCH<br>PUT<br>DELETE | /admin/posts/:id(.:format) <br> /admin/posts/:id(.:format) <br> /admin/posts/:id(.:format) <br> /admin/posts/:id(.:format) | admin/posts#show <br> admin/posts#update <br> admin/posts#update <br> admin/posts#destroy |

---

## Controller Namespaces and Routing

app/controllers/admin/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class Admin::PostsController
  # ...
end
```

config/routes.rb <!-- .element: class="filename" -->

```ruby
scope module: 'admin' do
  resources :posts, :comments
end
```

or for a single case

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :posts, module: 'admin'
```

---

## Route without a module prefix

config/routes.rb <!-- .element: class="filename" -->

```ruby
scope '/admin' do
  resources :posts, :comments
end
```

or for a single case:

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :posts, path: '/admin/posts'
```

| Prefix    |              Verb             | URI Pattern                                                                                                          | Controller#Action                                           |
|-----------|:-----------------------------:|----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| posts     | GET<br>POST                   |                                   /admin/posts(.:format)<br>/admin/posts(.:format)                                   | posts#index<br>posts#create                                 |
| new_post  | GET                           | /admin/posts/new(.:format)                                                                                           | posts#new                                                   |
| edit_post | GET                           | /admin/posts/:id/edit(.:format)                                                                                      | posts#edit                                                  |
| post      | GET<br>PATCH<br>PUT<br>DELETE | /admin/posts/:id(.:format)<br>/admin/posts/:id(.:format)<br>/admin/posts/:id(.:format)<br>/admin/posts/:id(.:format) | posts#show<br>posts#update<br>posts#update<br>posts#destroy |

---

## Nested Resources

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ActiveRecord::Base
  has_many :posts
end
```

app/models/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ActiveRecord::Base
  belongs_to :user
end
```

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :users do
  resources :posts
end
```

--

| Prefix         |              Verb             | URI Pattern                                                                                                                                              | Controller#Action                                           |
|----------------|:-----------------------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| user_posts     | GET<br>POST                   |                                            /users/:user_id/posts(.:format)<br>/users/:user_id/posts(.:format)                                            | posts#index<br>posts#create                                 |
| new_user_post  | GET                           | /users/:user_id/posts/new(.:format)                                                                                                                      | posts#new                                                   |
| edit_user_post | GET                           | /users/:user_id/posts/:id/edit(.:format)                                                                                                                 | posts#edit                                                  |
| user_post      | GET<br>PATCH<br>PUT<br>DELETE | /users/:user_id/posts/:id(.:format)<br>/users/:user_id/posts/:id(.:format)<br>/users/:user_id/posts/:id(.:format)<br>/users/:user_id/posts/:id(.:format) | posts#show<br>posts#update<br>posts#update<br>posts#destroy |

---

## Nested Resources

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :users do
  resources :posts do
    resources :comments
  end
end
```

```output
user_post_comments     GET        /users/:user_id/posts/:post_id/comments(.:format)          comments#index
                       POST       /users/:user_id/posts/:post_id/comments(.:format)          comments#create
new_user_post_comment  GET        /users/:user_id/posts/:post_id/comments/new(.:format)      comments#new
edit_user_post_comment GET        /users/:user_id/posts/:post_id/comments/:id/edit(.:format) comments#edit
user_post_comment      GET        /users/:user_id/posts/:post_id/comments/:id(.:format)      comments#show
                       PUT        /users/:user_id/posts/:post_id/comments/:id(.:format)      comments#update
                       DELETE     /users/:user_id/posts/:post_id/comments/:id(.:format)      comments#destroy
user_posts             GET        /users/:user_id/posts(.:format)                            posts#index
                       POST       /users/:user_id/posts(.:format)                            posts#create
new_user_post          GET        /users/:user_id/posts/new(.:format)                        posts#new
edit_user_post         GET        /users/:user_id/posts/:id/edit(.:format)                   posts#edit
user_post              GET        /users/:user_id/posts/:id(.:format)                        posts#show
                       PUT        /users/:user_id/posts/:id(.:format)                        posts#update
                       DELETE     /users/:user_id/posts/:id(.:format)                        posts#destroy
users                  GET        /users(.:format)                                           users#index
                       POST       /users(.:format)                                           users#create
new_user               GET        /users/new(.:format)                                       users#new
edit_user              GET        /users/:id/edit(.:format)                                  users#edit
user                   GET        /users/:id(.:format)                                       users#show
                       PUT        /users/:id(.:format)                                       users#update
                       DELETE     /users/:id(.:format)                                       users#destroy
```

---

## Shallow Nesting

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :posts do
  resources :comments, only: [:index, :new, :create]
end

resources :comments, only: [:show, :edit, :update, :destroy]
```

--

There exists shorthand syntax to achieve just that, via the :shallow option:

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :posts do
  resources :comments, shallow: true
end
```

| Prefix           |              Verb             | URI Pattern                                                                                              | Controller#Action                                                       |
|------------------|:-----------------------------:|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| post_comments    | GET<br>POST                   |                 /posts/:post_id/comments(.:format)<br>/posts/:post_id/comments(.:format)                 | comments#index<br>comments#create                                       |
| new_post_comment | GET                           | /posts/:post_id/comments/new(.:format)                                                                   | comments#new                                                            |
| edit_comment     | GET                           | /comments/:id/edit(.:format)                                                                             | comments#edit                                                           |
| comment          | GET<br>PATCH<br>PUT<br>DELETE | /comments/:id(.:format)<br>/comments/:id(.:format)<br>/comments/:id(.:format)<br>/comments/:id(.:format) | comments#show<br>comments#update<br>comments#update<br>comments#destroy |
| posts            | GET<br>POST                   | /posts(.:format)<br>/posts(.:format)                                                                     | posts#index<br>posts#create                                             |
| new_post         | GET                           | /posts/new(.:format)                                                                                     | posts#new                                                               |
| edit_post        | GET                           | /posts/:id/edit(.:format)                                                                                | posts#edit                                                              |
| post             | GET<br>PATCH<br>PUT<br>DELETE | /posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format)             | posts#show<br>posts#update<br>posts#update<br>posts#destroy             |

---

## Routing concerns

```ruby
resources :messages do
  resources :comments
end

resources :posts do
  resources :comments
  resources :images, only: :index
end
```

let's refactor it:

```ruby
concern :commentable do
  resources :comments
end

concern :image_attachable do
  resources :images, only: :index
end

resources :messages, concerns: :commentable
resources :posts, concerns: [:commentable, :image_attachable]
```

---

## Creating Paths and URLs From Objects

```ruby
resources :users do
  resources :posts
end
```

`link_to` helper

```ruby
= link_to 'Post details', user_post_path(@user, @post)
# => 'Post details'

= link_to 'Post details', url_for([@user, @post])
# => 'Post details'

= link_to 'Post details', [@user, @post]
# => 'Post details'

= link_to 'User details', @user
# => 'User details'

= link_to 'Edit Post', [:edit, @user, @post]
# => 'Edit Post'
```

---

## Adding More RESTful Actions

```ruby
resources :posts do
  member do
    get :preview
  end

  collection do
    get :search
  end
end
```

or

```ruby
resources :posts do
  get :preview, on: :member
  get :search, on: :collection
end
```

--

| Prefix       |              Verb             | URI Pattern                                                                                  | Controller#Action                                           |
|--------------|:-----------------------------:|----------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| preview_post | GET                           |                                 /posts/:id/preview(.:format)                                 | posts#preview                                               |
| search_posts | GET                           | /posts/search(.:format)                                                                      | posts#search                                                |
| posts        | GET<br>POST                   | /posts(.:format)<br>/posts(.:format)                                                         | posts#index<br>posts#create                                 |
| new_post     | GET                           | /posts/new(.:format)                                                                         | posts#new                                                   |
| edit_post    | GET                           | /posts/:id/edit(.:format)                                                                    | posts#edit                                                  |
| post         | GET<br>PATCH<br>PUT<br>DELETE | /posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format) | posts#show<br>posts#update<br>posts#update<br>posts#destroy |

---

## Non-Resourceful Routes

```ruby
get '/posts/:id', to: 'posts#show'
put '/posts/:id', to: 'posts#update'
delete '/posts/:id', to: 'posts#destroy'
post '/posts', to: 'posts#create'
```

```bash
$ rake routes
GET    /posts/:id(.:format) posts#show
PUT    /posts/:id(.:format) posts#update
DELETE /posts/:id(.:format) posts#destroy
POST   /posts(.:format)     posts#create
```

---

## Naming Routes

config/routes.rb <!-- .element: class="filename" -->

```ruby
get 'exit', to: 'sessions#destroy', as: :logout
get ':username', to: 'users#show', as: :user
```

```ruby
logout_path
# => /exit

user_path(username: 'ruby')
# => /ruby
```

---

## HTTP Verb Constraints

config/routes.rb <!-- .element: class="filename" -->

```ruby
match 'posts', to: 'posts#show', via: [:get, :post]
```

```bash
$ rake routes
posts GET|POST /posts(.:format) posts#show
```

---

## Segment Constraints

```ruby
get 'posts/:id', to: 'posts#show', constraints: {id: /[A-Z]\d{5}/}
```

or

```ruby
get 'posts/:id', to: 'posts#show', id: /[A-Z]\d{5}/
```

---

## Advanced Constraints

```ruby
class BlacklistConstraint
  def initialize
    @ips = Blacklist.retrieve_ips
  end

  def matches?(request)
    @ips.include?(request.remote_ip)
  end
end

Community::Application.routes.draw do
  get '*path', to: 'blacklist#index', constraints: BlacklistConstraint.new
end
```

```ruby
Community::Application.routes.draw do
  get '*path', to: 'blacklist#index', constraints: lambda { |request| Blacklist.retrieve_ips.include?(request.remote_ip) }
end
```

---

## Route Globbing

Example:

```ruby
get 'posts/*other', to: 'posts#unknown'
```

```output
/posts/12               => params[:other] == "12"
/posts/long/path/to/12  => params[:other] == "long/path/to/12"
```

Another example:

```ruby
get 'posts/*section/:title', to: 'posts#show'
```

```ruby
/posts/long/path/to/12 => params[:section] == "long/path/to", params[:title] == 12
```

---

## Redirection

```ruby
get '/stories', to: redirect('/posts')
get '/stories/:name', to: redirect('/posts/%{name}')
get '/stories/:name', to: redirect {|path_params, req| "/posts/#{path_params[:name].pluralize}" }
get '/stories', to: redirect {|path_params, req| "/posts/#{req.subdomain}" }
```

---

## Using Root

```ruby
root to: 'pages#main'
```

Shortcut

```ruby
root 'pages#main'
```

---

## Specifying a ControllerNamed Helper

```ruby
resources :posts, controller: 'messages'
```

| Prefix    |              Verb             | URI Pattern                                                                                  | Controller#Action                                                       |
|-----------|:-----------------------------:|----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| posts     | GET<br>POST                   |                             /posts(.:format)<br>/posts(.:format)                             | messages#index<br>messages#create                                       |
| new_post  | GET                           | /posts/new(.:format)                                                                         | messages#new                                                            |
| edit_post | GET                           | /posts/:id/edit(.:format)                                                                    | messages#edit                                                           |
| post      | GET<br>PATCH<br>PUT<br>DELETE | /posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format) | messages#show<br>messages#update<br>messages#update<br>messages#destroy |

---

## Overriding the Named Helpers

```ruby
resources :posts, as: 'messages'
```

| Prefix       |              Verb             | URI Pattern                                                                                  | Controller#Action                                           |
|--------------|:-----------------------------:|----------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| messages     | GET<br>POST                   |                             /posts(.:format)<br>/posts(.:format)                             | posts#index<br>posts#create                                 |
| new_message  | GET                           | /posts/new(.:format)                                                                         | posts#new                                                   |
| edit_message | GET                           | /posts/:id/edit(.:format)                                                                    | posts#edit                                                  |
| message      | GET<br>PATCH<br>PUT<br>DELETE | /posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format)<br>/posts/:id(.:format) | posts#show<br>posts#update<br>posts#update<br>posts#destroy |

---

## Restricting the Routes Created

```ruby
resources :users, except: :destroy
resources :posts, only: [:index, :show]
```

| Prefix    |         Verb        | URI Pattern                                                          | Controller#Action                          |
|-----------|:-------------------:|----------------------------------------------------------------------|--------------------------------------------|
| users     | GET<br>POST         |                 /users(.:format)<br>/users(.:format)                 | users#index<br>users#create                |
| new_user  | GET                 | /users/new(.:format)                                                 | users#new                                  |
| edit_user | GET                 | /users/:id/edit(.:format)                                            | users#edit                                 |
| user      | GET<br>PATCH<br>PUT | /users/:id(.:format)<br>/users/:id(.:format)<br>/users/:id(.:format) | users#show<br>users#update<br>users#update |
| posts     | GET                 | /posts(.:format)                                                     | posts#index                                |
| post      | GET                 | /posts/:id(.:format)                                                 | posts#show                                 |

---

## Routing specs

Routing specs live in spec/routing.

spec/routing/users_spec.rb <!-- .element: class="filename" -->

```ruby
require 'rails_helper'

describe "routing to users" do
  it "routes /users/:username to users#show for username" do
    expect(get: "/users/schmidt").to route_to(
      controller: "users",
      action: "show",
      username: "schmidt"
    )
  end

  it "does not expose a delete" do
    expect(delete: "/users/1").not_to be_routable
  end
end
```

---

# The End

<br>

[Go to Table of Contents](/)
