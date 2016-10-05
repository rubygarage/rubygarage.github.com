---
layout: slide
title:  Controllers
---

# Action Controller
`Action Controller` is the `C` in [MVC][1]. After routing has determined which controller to use for a request,
your controller is responsible for making sense of the request and producing the appropriate output.
![](assets/mvc.png){: .mvc}

---

## Methods and Actions
config/routes.rb
```ruby
resources :posts, only: [:index] # GET /posts
```
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## CRUD actions
config/routes.rb
```ruby
resources :posts
```
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Parameters
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Hash and Array Parameters
app/controllers/posts_controller.rb
```ruby
class PostsController  ["1", "2", "3"]
...
end
end
```
app/views/posts/_form.html.erb
```ruby
```
app/controllers/posts_controller.rb
```ruby
class PostsController  { title: "Title", images_attributes: { id: "12345", title: "Image" } }
...
end
end
```

---

## JSON parameters
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Routing parameters
config/routes.rb
```ruby
get '/posts/:state' => 'posts#index', my: true
```
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Default URL options
app/controllers/application_controller.rb
```ruby
class ApplicationController  /posts/new?locale=en
{ locale: I18n.locale }
end
end
```

---

## Strong parameters
app/controllers/posts_controller.rb
```ruby
class PostsController
```ruby
params.permit(:id)
params.permit(:id => [])
params.require(:post).permit!
params.permit(:title, {:comments => []},
:images_attributes => [:id, :name, :_destroy])
params.fetch(:post, {}).permit(:title, :text)
```
```ruby
def post_params
params.require(:post).permit(:title).tap do |whitelisted|
whitelisted[:data] = params[:post][:data]
end
end
```

---

## Session
* ActionDispatch::Session::CookieStore - Stores everything on the client
* ActionDispatch::Session::CacheStore - Stores the data in the Rails cache
* ActionDispatch::Session::ActiveRecordStore - Stores the data in a database using Active Record (require
activerecord-session_store gem)
* ActionDispatch::Session::MemCacheStore - Stores the data in a memcached cluster (this is a legacy implementation;
consider using CacheStore instead)
config/initializers/session_store.rb
```ruby
YourApp::Application.config.session_store :active_record_store
```
```ruby
YourApp::Application.config.session_store :cookie_store, key: '_your_app_session'
```
```ruby
YourApp::Application.config.session_store :cookie_store, key: '_your_app_session', domain: ".example.com"
```
config/initializers/secret_token.rb
```ruby
YourApp::Application.config.secret_key_base = '49d3f3de9ed86c74b94ad6bd0...'
```
This token is used to sign cookies that the application sets. Without this, it's impossible to trust cookies that the
browser sends, and hence difficult to rely on session based authentication.

---

## Accessing the session
app/controllers/application_controller.rb
```ruby
class ApplicationController
app/controllers/logins_controller.rb
```ruby
class LoginsController
```ruby
reset_session
```

---

## The Flash
app/controllers/logins_controller.rb
```ruby
class LoginsController
```ruby
redirect_to root_url, notice: "You have successfully logged out."
redirect_to root_url, alert: "You're stuck here!"
redirect_to root_url, flash: { just_signed_up: true }
```
### Show messages
app/views/layouts/application.html.erb
```ruby
```
```ruby
Welcome to our site!
```
### Keep to another request
app/controllers/posts_controller.rb
```ruby
class PostsController
### Use now
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Cookies
app/controllers/comments_controller.rb
```ruby
class CommentsController
### Sets a cookie that expires in 1 hour
```ruby
cookies[:login] = { value: "XJ-122", expires: 1.hour.from_now }
```
### Sets a signed cookie, which prevents users from tampering with its value
```ruby
cookies.signed[:user_id] = current_user.id
```
### Sets a "permanent" cookie (which expires in 20 years from now)
```ruby
cookies.permanent[:login] = "XJ-122"
```

---

## Rendering XML and JSON data
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Before/after actions
app/controllers/application_controller.rb
```ruby
class ApplicationController
app/controllers/posts_controller.rb
```ruby
class PostsController
### Skip before/after action
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Around actions
app/controllers/posts_controller.rb
```ruby
class PostsController  "It broke!"
end
end
end
```
### Filter block
app/controllers/application_controller.rb
```ruby
class ApplicationController
### Filter class
app/controllers/application_controller.rb
```ruby
class ApplicationController

---

## Request forgery protection
```ruby
```
```ruby
```
` form_authenticity_token ` app/controllers/application_controller.rb
```ruby
protect_from_forgery with: :exception
```
for apis
```ruby
protect_from_forgery with: :null_session
```

---

## Request object
app/controllers/application_controller.rb
```ruby
class ApplicationController
| Property of request | Purpose |
|

---

| host | The hostname used for this request. |
| domain(n=2) | The hostname's first n segments, starting from the right (the TLD). |
| format | The content type requested by the client. |
| method | The HTTP method used for the request. |
| get?, post?, patch?, put?, delete?, head? | Returns true if the HTTP method is GET/POST/PATCH/PUT/DELETE/HEAD. |
| headers | Returns a hash containing the headers associated with the request. |
| port | The port number (integer) used for the request. |
| protocol | Returns a string containing the protocol used plus "://", for example "http://". |
| query_string | The query string part of the URL, i.e., everything after "?". |
| remote_ip | The IP address of the client. |
| url | The entire URL used for the request. |
{: .table}

---

## Response object
app/controllers/application_controller.rb
```ruby
class ApplicationController
| Property of response | Purpose |
|

---

| body | This is the string of data being sent back to the client. This is most often HTML. |
| status | The HTTP status code for the response, like 200 for a successful request or 404 for file not found. |
| location | The URL the client is being redirected to, if any. |
| content_type | The content type of the response. |
| charset | The character set being used for the response. Default is "utf-8". |
| headers | Headers used for the response. |
{: .table}

---

## HTTP Authentications
* Basic Authentication
* Digest Authentication
### Basic Authentication
app/controllers/admins_controller.rb
```ruby
class AdminsController
### Digest Authentication
app/controllers/admins_controller.rb
```ruby
class AdminsController  "bar" }
before_action :authenticate
private
def authenticate
authenticate_or_request_with_http_digest do |username|
USERS[username]
end
end
end
```

---

## Streaming
app/controllers/posts_controller.rb
```ruby
require "prawn"
class PostsController

---

## Sending files
If you want to send a file that already exists on disk, use the send_file method.
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## RESTful Downloads
app/controllers/posts_controller.rb
```ruby
class PostsController
config/initializers/mime_types.rb
```ruby
Mime::Type.register "application/pdf", :pdf
```

---

## Live streaming of arbitrary data
ActionController::Live module allows to create a persistent connection with a browser.
### Incorporating live streaming
```ruby
class PostsController
```ruby
class PostsController
### Streaming considerations
* Each response stream creates a new thread and copies over the thread local variables from the original thread. Having
too many thread local variables can negatively impact performance. Similarly, a large number of threads can also
hinder performance.
* Failing to close the response stream will leave the corresponding socket open forever. Make sure to call close
whenever you are using a response stream.
* WEBrick servers buffer all responses, and so including ActionController::Live will not work. You must use a web
server which does not automatically buffer responses.

---

## Log Filtering
### Parameters Filtering
```ruby
config.filter_parameters
### Redirects Filtering
```ruby
config.filter_redirect
```ruby
config.filter_redirect.concat ['s3.amazonaws.com', /private_path/]
```

---

## rescue_from
app/controllers/application_controller.rb
```ruby
class ApplicationController
app/controllers/application_controller.rb
```ruby
class ApplicationController
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Force HTTPS protocol
app/controllers/posts_controller.rb
```ruby
class PostsController
force_ssl
end
```
app/controllers/posts_controller.rb
```ruby
class PostsController
force_ssl only: [:new, :create, :update, :edit]
end
```
```ruby
class PostsController
force_ssl except: :index
end
```

---

## Example
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Testing
spec/factories/users.rb
```ruby
FactoryGirl.define do
factory :user do
email { Faker::Internet.email }
name { Faker::Name.name }
end
end
```
spec/factories/posts.rb
```ruby
FactoryGirl.define do
factory :post do
title { Faker::Lorem.sentence }
text { Faker::Lorem.paragraph }
user
end
end
```
spec/controllers/posts_controller_spec.rb
```ruby
require 'spec_helper'
describe PostsController do
let(:post_params) { FactoryGirl.attributes_for(:post).stringify_keys }
let(:post) { FactoryGirl.build_stubbed(:post) }
let(:user) { FactoryGirl.create(:user) }
describe "GET #show" do
before do
allow(Post).to receive(:find).and_return post
end
it "receives find and return post" do
expect(Post).to receive(:find).with(post.id.to_s)
get :show, id: post.id
end
it "assigns @post" do
get :show, id: post.id
expect(assigns(:post)).not_to be_nil
end
it "renders :show template" do
get :show, id: post.id
expect(response).to render_template :show
end
end
describe "PUT #update" do
context "without ability to update" do
before do
allow(user).to receive_message_chain(:posts, :find).and_return nil
allow(controller).to receive(:current_user).and_return user
put :update, id: post.id, post: post_params
end
it "redirects to root page" do
expect(response).to redirect_to(root_path)
end
it "sends notice" do
expect(flash[:notice]).to eq 'Not authorized user.'
end
end
context "with valid attributes" do
before do
allow(post).to receive(:update).and_return true
allow(user).to receive_message_chain(:posts, :find).and_return post
allow(controller).to receive(:current_user).and_return user
end
it "assigns @post" do
put :update, id: post.id, post: post_params
expect(assigns(:post)).not_to be_nil
end
it "receives update for @post" do
expect(post).to receive(:update).with(post_params)
put :update, id: post.id, post: post_params
end
it "sends success notice" do
put :update, id: post.id, post: post_params
expect(flash[:notice]).to eq 'Post was successfully updated.'
end
it "redirects to post page" do
put :update, id: post.id, post: post_params
expect(response).to redirect_to post
end
end
context "with forbidden attributes" do
before do
allow(post).to receive(:update).and_return true
allow(user).to receive_message_chain(:posts, :find).and_return post
allow(controller).to receive(:current_user).and_return user
end
it "generates ParameterMissing error without post params" do
expect { put :update, id: post.id }.to raise_error(ActionController::ParameterMissing)
end
it "filters forbidden params" do
expect(post).to receive(:update).with(post_params)
put :update, id: post.id, post: post_params.merge(user_id: 1)
end
end
context "with invalid attributes" do
before do
allow(post).to receive(:update).and_return false
allow(user).to receive_message_chain(:posts, :find).and_return post
allow(controller).to receive(:current_user).and_return user
end
it "sends error flash" do
put :update, id: post.id, post: post_params
expect(flash[:error]).to eq 'Could not save post.'
end
it "renders :edit template" do
put :update, id: post.id, post: post_params
expect(response).to render_template :edit
end
end
end
end
```
[1]: http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller
