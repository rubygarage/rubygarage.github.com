---
layout: slide
title:  Routes
---

# Routes
The Rails router recognizes URLs and dispatches them to a controller's action. It can also generate paths and URLs,
avoiding the need to hardcode strings in your views.

---

## Routes
When your Rails application receives an incoming request for:
```ruby
GET /posts/17
```
it asks the router to match it to a controller action. If the first matching route is:
config/routes.rb
```ruby
get '/posts/:id', to: 'posts#show', as: 'post'
```
the request is dispatched to the posts controller's show action with { id: '17' } in params.
app/controllers/posts_controller.rb
```ruby
def show
@post = Post.find(params[:id])
end
```
app/views/posts/show.html.erb
```ruby
```

---

## CRUD, Verbs, and Actions
Resource routing allows you to quickly declare all of the common routes for a given resourceful controller. Instead of
declaring separate routes for your index, show, new, edit, create, update and destroy actions, a resourceful route
declares them in a single line of code.
config/routes.rb
```ruby
Community::Application.routes.draw do
resources :posts
end
```
Prefix
Verb
URI Pattern
Controller#Action
posts
GET
/posts(.:format)
posts#index
POST
/posts(.:format)
posts#create
new_post
GET
/posts/new(.:format)
posts#new
edit_post
GET
/posts/:id/edit(.:format)
posts#edit
post
GET
/posts/:id(.:format
posts#show
PATCH
/posts/:id(.:format)
posts#update
PUT
/posts/:id(.:format)
posts#update
DELETE
/posts/:id(.:format
posts#destroy
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
Prefix
Verb
URI Pattern
Controller#Action
user
POST
/user(.:format)
users#create
new_user
GET
/user/new(.:format)
users#new
edit_user
GET
/user/edit(.:format)
users#edit
GET
/user(.:format)
users#show
PATCH
/user(.:format)
users#update
PUT
/user(.:format)
users#update
DELETE
/user(.:format)
users#destroy

---

## Controller Namespaces and Routing
```ruby
namespace :admin do
resources :posts
end
```
Prefix
Verb
URI Pattern
Controller#Action
admin_posts
GET
/admin/posts(.:format)
admin/posts#index
POST
/admin/posts(.:format)
admin/posts#create
new_admin_post
GET
/admin/posts/new(.:format)
admin/posts#new
edit_admin_post
GET
/admin/posts/:id/edit(.:format)
admin/posts#edit
admin_post
GET
/admin/posts/:id(.:format)
admin/posts#show
PATCH
/admin/posts/:id(.:format)
admin/posts#update
PUT
/admin/posts/:id(.:format)
admin/posts#update
DELETE
/admin/posts/:id(.:format)
admin/posts#destroy

---

## Controller Namespaces and Routing
app/controllers/admin/posts_controller.rb
```ruby
class Admin::PostsController
config/routes.rb
```ruby
scope module: 'admin' do
resources :posts, :comments
end
```
or for a single case
config/routes.rb
```ruby
resources :posts, module: 'admin'
```

---

## Route without a module prefix
config/routes.rb
```ruby
scope '/admin' do
resources :posts, :comments
end
```
or for a single case:
config/routes.rb
```ruby
resources :posts, path: '/admin/posts'
```
Prefix
Verb
URI Pattern
Controller#Action
posts
GET
/admin/posts(.:format)
posts#index
POST
/admin/posts(.:format)
posts#create
new_post
GET
/admin/posts/new(.:format)
posts#new
edit_post
GET
/admin/posts/:id/edit(.:format)
posts#edit
post
GET
/admin/posts/:id(.:format)
posts#show
PATCH
/admin/posts/:id(.:format)
posts#update
PUT
/admin/posts/:id(.:format)
posts#update
DELETE
/admin/posts/:id(.:format)
posts#destroy

---

## Nested Resources
app/models/user.rb
```ruby
class User
app/models/post.rb
```ruby
class Post
config/routes.rb
```ruby
resources :users do
resources :posts
end
```
Prefix
Verb
URI Pattern
Controller#Action
user_posts
GET
/users/:user_id/posts(.:format)
posts#index
POST
/users/:user_id/posts(.:format)
posts#create
new_user_post
GET
/users/:user_id/posts/new(.:format)
posts#new
edit_user_post
GET
/users/:user_id/posts/:id/edit(.:format)
posts#edit
user_post
GET
/users/:user_id/posts/:id(.:format)
posts#show
PATCH
/users/:user_id/posts/:id(.:format)
posts#update
PUT
/users/:user_id/posts/:id(.:format)
posts#update
DELETE
/users/:user_id/posts/:id(.:format)
posts#destroy

---

## Nested Resources
config/routes.rb
```ruby
resources :users do
resources :posts do
resources :comments
end
end
```
```bash
user_post_comments GET        /users/:user_id/posts/:post_id/comments(.:format)          comments#index
POST       /users/:user_id/posts/:post_id/comments(.:format)          comments#create
new_user_post_comment GET        /users/:user_id/posts/:post_id/comments/new(.:format)      comments#new
edit_user_post_comment GET        /users/:user_id/posts/:post_id/comments/:id/edit(.:format) comments#edit
user_post_comment GET        /users/:user_id/posts/:post_id/comments/:id(.:format)      comments#show
PUT        /users/:user_id/posts/:post_id/comments/:id(.:format)      comments#update
DELETE     /users/:user_id/posts/:post_id/comments/:id(.:format)      comments#destroy
user_posts GET        /users/:user_id/posts(.:format)                            posts#index
POST       /users/:user_id/posts(.:format)                            posts#create
new_user_post GET        /users/:user_id/posts/new(.:format)                        posts#new
edit_user_post GET        /users/:user_id/posts/:id/edit(.:format)                   posts#edit
user_post GET        /users/:user_id/posts/:id(.:format)                        posts#show
PUT        /users/:user_id/posts/:id(.:format)                        posts#update
DELETE     /users/:user_id/posts/:id(.:format)                        posts#destroy
users GET        /users(.:format)                                           users#index
POST       /users(.:format)                                           users#create
new_user GET        /users/new(.:format)                                       users#new
edit_user GET        /users/:id/edit(.:format)                                  users#edit
user GET        /users/:id(.:format)                                       users#show
PUT        /users/:id(.:format)                                       users#update
DELETE     /users/:id(.:format)                                       users#destroy
```

---

## Shallow Nesting
config/routes.rb
```ruby
resources :posts do
resources :comments, only: [:index, :new, :create]
end
resources :comments, only: [:show, :edit, :update, :destroy]
```
There exists shorthand syntax to achieve just that, via the :shallow option:
config/routes.rb
```ruby
resources :posts do
resources :comments, shallow: true
end
```
Prefix
Verb
URI Pattern
Controller#Action
post_comments
GET
/posts/:post_id/comments(.:format)
comments#index
POST
/posts/:post_id/comments(.:format)
comments#create
new_post_comment
GET
/posts/:post_id/comments/new(.:format)
comments#new
edit_comment
GET
/comments/:id/edit(.:format)
comments#edit
comment
GET
/comments/:id(.:format)
comments#show
PATCH
/comments/:id(.:format)
comments#update
PUT
/comments/:id(.:format)
comments#update
DELETE
/comments/:id(.:format)
comments#destroy
posts
GET
/posts(.:format)
posts#index
POST
/posts(.:format)
posts#create
new_post
GET
/posts/new(.:format)
posts#new
edit_post
GET
/posts/:id/edit(.:format)
posts#edit
post
GET
/posts/:id(.:format)
posts#show
PATCH
/posts/:id(.:format)
posts#update
PUT
/posts/:id(.:format)
posts#update
DELETE
/posts/:id(.:format)
posts#destroy

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
#=> 'Post details'
= link_to 'Post details', url_for([@user, @post])
#=> 'Post details'
= link_to 'Post details', [@user, @post]
#=> 'Post details'
= link_to 'User details', @user
#=> 'User details'
= link_to 'Edit Post', [:edit, @user, @post]
#=> 'Edit Post'
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
Prefix
Verb
URI Pattern
Controller#Action
preview_post
GET
/posts/:id/preview(.:format)
posts#preview
search_posts
GET
/posts/search(.:format)
posts#search
posts
GET
/posts(.:format)
posts#index
POST
/posts(.:format)
posts#create
new_post
GET
/posts/new(.:format)
posts#new
edit_post
GET
/posts/:id/edit(.:format)
posts#edit
post
GET
/posts/:id(.:format)
posts#show
PATCH
/posts/:id(.:format)
posts#update
PUT
/posts/:id(.:format)
posts#update
DELETE
/posts/:id(.:format)
posts#destroy

---

## Non-Resourceful Routes
```ruby
get '/posts/:id', to: 'posts#show'
put '/posts/:id', to: 'posts#update'
delete '/posts/:id', to: 'posts#destroy'
post '/posts', to: 'posts#create'
```
```bash
rake routes
GET    /posts/:id(.:format) posts#show
PUT    /posts/:id(.:format) posts#update
DELETE /posts/:id(.:format) posts#destroy
POST   /posts(.:format)     posts#create
```

---

## Naming Routes
config/routes.rb
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
config/rputes.rb
```ruby
match 'posts', to: 'posts#show', via: [:get, :post]
```
```bash
rake routes
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
```ruby
/posts/12               => params[:other] == "12"
/posts/long/path/to/12  => params[:other] == "long/path/to/12"
```
Another example:
```ruby
get 'posts/*section/:title', to: 'posts#show'
```
```ruby
/posts/long/path/to/12  => params[:section] == "long/path/to", params[:title] == 12
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
Prefix
Verb
URI Pattern
Controller#Action
posts
GET
/posts(.:format)
messages#index
POST
/posts(.:format)
messages#create
new_post
GET
/posts/new(.:format)
messages#new
edit_post
GET
/posts/:id/edit(.:format)
messages#edit
post
GET
/posts/:id(.:format)
messages#show
PATCH
/posts/:id(.:format)
messages#update
PUT
/posts/:id(.:format)
messages#update
DELETE
/posts/:id(.:format)
messages#destroy

---

## Overriding the Named Helpers
```ruby
resources :posts, as: 'messages'
```
Prefix
Verb
URI Pattern
Controller#Action
messages
GET
/posts(.:format)
posts#index
POST
/posts(.:format)
posts#create
new_message
GET
/posts/new(.:format)
posts#new
edit_message
GET
/posts/:id/edit(.:format)
posts#edit
message
GET
/posts/:id(.:format)
posts#show
PATCH
/posts/:id(.:format)
posts#update
PUT
/posts/:id(.:format)
posts#update
DELETE
/posts/:id(.:format)
posts#destroy

---

## Restricting the Routes Created
```ruby
resources :users, except: :destroy
resources :posts, only: [:index, :show]
```
Prefix
Verb
URI Pattern
Controller#Action
users
GET
/users(.:format)
users#index
POST
/users(.:format)
users#create
new_user
GET
/users/new(.:format)
users#new
edit_user
GET
/users/:id/edit(.:format)
users#edit
user
GET
/users/:id(.:format)
users#show
PATCH
/users/:id(.:format)
users#update
PUT
/users/:id(.:format)
users#update
posts
GET
/posts(.:format)
posts#index
post
GET
/posts/:id(.:format)
posts#show

---

## Routing specs
Routing specs live in spec/routing.
spec/routing/users_spec.rb
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
