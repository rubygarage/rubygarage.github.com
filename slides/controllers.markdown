---
layout: slide
title:  Controllers
---

# Action Controller

`Action Controller` is the `C` in [MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller). After routing has determined which controller to use for a request,
your controller is responsible for making sense of the request and producing the appropriate output.

<br>

[Go to Table of Contents](/)

---

### MVC

![](/assets/images/mvc.svg)

---

# Methods and Actions

config/routes.rb <!-- .element: class="filename" -->
```ruby
resources :posts, only: [:index] # GET /posts
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->
```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
```

---

# CRUD actions

config/routes.rb <!-- .element: class="filename" -->
```ruby
resources :posts
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->
```ruby
class PostsController < ApplicationController
  def index   # GET /posts
    # ...
  end

  def show    # GET /posts/:id
    # ...
  end

  def new     # GET /posts/new
    # ...
  end

  def edit    # GET /posts/:id/edit
    # ...
  end

  def create  # POST /posts/
    # ...
  end

  def update  # PATCH /posts/:id PUT /posts/:id
    # ...
  end

  def destroy # DELETE /posts/:id
    # ...
  end
end
```


---

# Parameters

app/controllers/posts_controller.rb <!-- .element: class="filename" -->
```ruby
class PostsController < ApplicationController
  # ...

  # GET by /posts?state=confirmed
  def index
    @posts = if params[:state] == 'confirmed'
      Post.confirmed
    else
      Post.unconfirmed
    end
  end

  # PATCH to /posts
  # id=12&post[name]=Foo&post[text]=Bar
  def update
    @post = Post.find(params[:id])
    @post.update(params[:post])

    # ...
  end

  # ...
end
```

---

## Hash and Array Parameters

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  # ...

  # GET /posts?ids[]=1&ids[]=2&ids[]=3
  def index
    params[:ids] # => ['1', '2', '3']
    # ...
  end
end
```

app/views/posts/_form.html.erb <!-- .element: class="filename" -->

```html
<form accept-charset="UTF-8" action="/posts" method="post">
  <input type="text" name="post[title]" value="Title" />
  <input type="text" name="post[images_attributes][id]" value="12345" />
  <input type="text" name="post[images_attributes][title]" value="Image" />
</form>
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  # ...

  def create
    params[:post] # => { title: 'Title', images_attributes: { id: '12345', title: 'Image' } }
    # ...
  end
end
```

---

# JSON parameters

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  # ...

  # { "post": { "title": "PostTitle", "text": "PostText" } }
  def create
    @post = Post.new(params[:post])
    # ...
  end

  # { "post": { "id": "12", "title": "UpdatedTitle", "images_attributes": { "title": "ImageTitle", file: "/tmp/file.png" } } }
  def update
    @post = Post.find_by_id params[:id]
    @post.update(params[:post])
  end
  # ...
end
```

---

# Routing parameters

config/routes.rb <!-- .element: class="filename" -->

```ruby
get '/posts/:state' => 'posts#index', my: true
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  # ...
  # GET /posts/active
  def index
    if params[:my]
      @posts = current_user.posts.where(state: params[:state])
    end
    # ...
  end
end
```

---

# Default URL options

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base

  def default_url_options # /posts/new -> /posts/new?locale=en
    { locale: I18n.locale }
  end
end
```

---

# Strong parameters

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ActionController::Base
  def create # ActiveModel::ForbiddenAttributes exception
    Post.create(post_params)
  end

  def update
    post = current_user.posts.find(params[:id])
    post.update(post_params)
    redirect_to post
  end

  private
    def post_params
      params.require(:post).permit(:title, :text)
    end
end
```

--

## Use cases

```ruby
params.permit(:id)
params.permit(:id => [])
params.require(:post).permit!
params.permit(:title, { comments: [] }, images_attributes: [:id, :name, :_destroy])

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

# Session

* `ActionDispatch::Session::CookieStore` - Stores everything on the client

* `ActionDispatch::Session::CacheStore` - Stores the data in the Rails cache

* `ActionDispatch::Session::ActiveRecordStore` - Stores the data in a database using Active Record (require
activerecord-session_store gem)

* `ActionDispatch::Session::MemCacheStore` - Stores the data in a memcached cluster (this is a legacy implementation;
consider using CacheStore instead)

--

## Configuration

config/initializers/session_store.rb <!-- .element: class="filename" -->

```ruby
YourApp::Application.config.session_store :active_record_store
YourApp::Application.config.session_store :cookie_store, key: '_your_app_session'
YourApp::Application.config.session_store :cookie_store, key: '_your_app_session', domain: ".example.com"
```

config/initializers/secret_token.rb <!-- .element: class="filename" -->

```ruby
YourApp::Application.config.secret_key_base = '49d3f3de9ed86c74b94ad6bd0...'
```

<br>

This token is used to sign cookies that the application sets. Without this, it's impossible to trust cookies that the
browser sends, and hence difficult to rely on session based authentication.

---

# Accessing the session

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  # ...

  private

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end
end
```

--

app/controllers/logins_controller.rb <!-- .element: class="filename" -->

```ruby
class LoginsController < ApplicationController
  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:current_user_id] = user.id
      redirect_to root_url
    end
  end

  def destroy
    @_current_user = session[:current_user_id] = nil
    redirect_to root_url
  end
end
```

```ruby
reset_session
```

---

# The Flash

app/controllers/logins_controller.rb <!-- .element: class="filename" -->

```ruby
class LoginsController < ApplicationController
  def destroy
    session[:current_user_id] = nil
    flash[:notice] = 'You have successfully logged out'
    redirect_to root_url
  end
end
```

```ruby
redirect_to root_url, notice: 'You have successfully logged out.'
redirect_to root_url, alert: "You're stuck here!"
redirect_to root_url, flash: { just_signed_up: true }
```

--

## Show messages

app/views/layouts/application.html.erb <!-- .element: class="filename" -->

```html
<body>
  <% flash.each do |name, msg| -%>
    <%= content_tag :div, msg, class: name %>
  <% end -%>
</body>
```

```html
<% if flash[:just_signed_up] %>
  <p class="welcome">Welcome to our site!</p>
<% end %>
```

--

## Keep to another request

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  def index
    flash.keep
    redirect_to users_url
  end
end
```

--

## Use now

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)

    if @post.save
      # ...
    else
      flash.now[:error] = 'Could not save post'
      render action: 'new'
    end
  end
end
```

---

# Cookies

app/controllers/comments_controller.rb <!-- .element: class="filename" -->

```ruby
class CommentsController < ApplicationController
  def new
    @comment = Comment.new(author: cookies[:commenter_name])
  end

  def create
    @comment = Comment.new(params[:comment])

    if @comment.save
      flash[:notice] = 'Thanks for your comment!'
      if params[:remember_name]
        cookies[:commenter_name] = @comment.author
      else
        cookies.delete(:commenter_name)
      end
      redirect_to @comment.post
    else
      render action: 'new'
    end
  end
end
```

--

### Sets a cookie that expires in 1 hour

```ruby
cookies[:login] = { value: 'XJ-122', expires: 1.hour.from_now }
```
### Sets a signed cookie, which prevents users from tampering with its value

```ruby
cookies.signed[:user_id] = current_user.id
```

### Sets a 'permanent' cookie (which expires in 20 years from now)

```ruby
cookies.permanent[:login] = 'XJ-122'
```

---

## Rendering XML and JSON data

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json # index.json.jbuilder
      format.xml  { render xml: @posts }
    end
  end
end
```

---

## Before/after actions

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to new_login_url
    end
  end
end
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  after_action :last_open_page

  # ...

  private

  def last_open_page
    session[:last_open_page] = Time.now
  end
end
```

--

## Skip before/after action

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
end
```

---

# Around actions

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  around_action :wrap_actions

  private

  def wrap_actions
    begin
      yield
    rescue
      render :text => 'It broke!'
    end
  end
end
```

--

## Filter block

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  before_action do |controller|
    redirect_to new_login_url unless controller.send(:logged_in?)
  end
end
```

## Filter class

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  before_action LoginFilter
end

class LoginFilter
  def self.before(controller)
    unless controller.send(:logged_in?)
      controller.flash[:error] = 'You must be logged in'
      controller.redirect_to controller.new_login_url
    end
  end
end
```

---

## Request forgery protection

```html
<%= form_for @user do |f| %>
  <%= f.text_field :username %>
  <%= f.text_field :password %>
<% end %>
```

```html
<form accept-charset="UTF-8" action="/users/1" method="post">
  <input type="hidden" value="12350adcf5eb5ad13451c00a5621854a23af5489" name="authenticity_token"/>

  <!-- fields -->
</form>
```

`form_authenticity_token`

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
protect_from_forgery with: :exception
```

for apis

```ruby
protect_from_forgery with: :null_session
```

---

# Request object

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  before_action :current_city
  # ...

  private

  def current_city
    session[:city] = City.find_by(ip: request.remote_ip)
  end
end
```

--

| Property of request | Purpose |
| ------------------- | ------- |
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

---

# Response object

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  after_action :check_response
  # ...

  private

  def check_response
    send_admin_email if response.status == 404
  end
end
```

--

| Property of response | Purpose |
| -------------------- | ------- |
| body | This is the string of data being sent back to the client. This is most often HTML. |
| status | The HTTP status code for the response, like 200 for a successful request or 404 for file not found. |
| location | The URL the client is being redirected to, if any. |
| content_type | The content type of the response. |
| charset | The character set being used for the response. Default is "utf-8". |
| headers | Headers used for the response. |

---

# HTTP Authentications

* Basic Authentication
* Digest Authentication

--

## Basic Authentication

app/controllers/admins_controller.rb <!-- .element: class="filename" -->

```ruby
class AdminsController < ApplicationController
  http_basic_authenticate_with name: 'foo', password: 'bar'
end
```

## Digest Authentication

app/controllers/admins_controller.rb <!-- .element: class="filename" -->

```ruby
class AdminsController < ApplicationController
  USERS = { "foo" => "bar" }

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

# Streaming

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
require 'prawn'

class PostsController < ApplicationController
  def download_pdf
    post = Post.find(params[:id])
    send_data generate_pdf(post),
              filename: "#{client.name}.pdf",
              type: 'application/pdf'
  end

  private

  def generate_pdf(post)
    Prawn::Document.new do
      text post.title, align: :center
      text post.text
    end.render
  end
end
```

---

# Sending files

If you want to send a file that already exists on disk, use the send_file method.

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  def download_pdf
    post = Post.find(params[:id])
    send_file("#{Rails.root}/files/posts/#{post.id}.pdf",
              filename: "#{post.title}.pdf",
              type: 'application/pdf')
  end
end
```

---

# RESTful Downloads

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  def show # GET /posts/1.pdf
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf { render pdf: generate_pdf(@post) }
    end
  end
end
```

config/initializers/mime_types.rb <!-- .element: class="filename" -->

```ruby
Mime::Type.register 'application/pdf', :pdf
```

---

# Live streaming of arbitrary data

ActionController::Live module allows to create a persistent connection with a browser.

--

## Incorporating live streaming

```ruby
class PostsController < ActionController::Base
  include ActionController::Live

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    100.times {
      response.stream.write Post.first.text
      sleep 1
    }
  ensure
    response.stream.close
  end
end
```

```ruby
class PostsController < ActionController::Base
  include ActionController::Live

  def show
    response.headers['Content-Type'] = 'text/event-stream'
    post = Post.find(params[:id])

    post.text.each do |line|
      response.stream.write line
      sleep 10
    end
  ensure
    response.stream.close
  end
end
```

--

## Streaming considerations

* Each response stream creates a new thread and copies over the thread local variables from the original thread. Having
too many thread local variables can negatively impact performance. Similarly, a large number of threads can also
hinder performance.

* Failing to close the response stream will leave the corresponding socket open forever. Make sure to call close
whenever you are using a response stream.

* WEBrick servers buffer all responses, and so including ActionController::Live will not work. You must use a web
server which does not automatically buffer responses.

---

# Log Filtering

## Parameters Filtering

```ruby
config.filter_parameters
```

## Redirects Filtering

```ruby
config.filter_redirect
```

```ruby
config.filter_redirect.concat ['s3.amazonaws.com', /private_path/]
```

---

# rescue_from

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render text: '404 Not Found', status: 404
  end
end
```

--

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  rescue_from User::NotAuthorized, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_to :back
  end
end
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  before_action :check_authorization

  def edit
    @post = Post.find(params[:id])
  end

  private

  def check_authorization
    raise User::NotAuthorized unless current_user.admin?
  end
end
```

---

# Force HTTPS protocol

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController
  force_ssl
end
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

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

# Example

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def update
    if current_user && @post = current_user.posts.find(params[:id])
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        flash.now[:error] = 'Could not save post.'
        render action: 'edit'
      end
    else
      redirect_to root_path, notice: 'Not authorized user.'
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
```

---

# Testing

spec/factories/users.rb <!-- .element: class="filename" -->

```ruby
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
```

spec/factories/posts.rb <!-- .element: class="filename" -->

```ruby
FactoryGirl.define do
  factory :post do
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
    user
  end
end
```

--

spec/controllers/posts_controller_spec.rb <!-- .element: class="filename" -->

```ruby
describe PostsController do
  let(:post_params) { FactoryGirl.attributes_for(:post).stringify_keys }
  let(:post) { FactoryGirl.build_stubbed(:post) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET #show' do
    before do
      allow(Post).to receive(:find).and_return post
    end

    it 'receives find and return post' do
      expect(Post).to receive(:find).with(post.id.to_s)
      get :show, id: post.id
    end

    it 'assigns @post' do
      get :show, id: post.id
      expect(assigns(:post)).not_to be_nil
    end

    it 'renders :show template' do
      get :show, id: post.id
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do
    context 'without ability to update' do
      before do
        allow(user).to receive_message_chain(:posts, :find).and_return nil
        allow(controller).to receive(:current_user).and_return user
        put :update, id: post.id, post: post_params
      end

      it 'redirects to root page' do
        expect(response).to redirect_to(root_path)
      end

      it 'sends notice' do
        expect(flash[:notice]).to eq 'Not authorized user.'
      end
    end

    context 'with valid attributes' do
      before do
        allow(post).to receive(:update).and_return true
        allow(user).to receive_message_chain(:posts, :find).and_return post
        allow(controller).to receive(:current_user).and_return user
      end

      it 'assigns @post' do
        put :update, id: post.id, post: post_params
        expect(assigns(:post)).not_to be_nil
      end

      it 'receives update for @post' do
        expect(post).to receive(:update).with(post_params)
        put :update, id: post.id, post: post_params
      end

      it 'sends success notice' do
        put :update, id: post.id, post: post_params
        expect(flash[:notice]).to eq 'Post was successfully updated.'
      end

      it 'redirects to post page' do
        put :update, id: post.id, post: post_params
        expect(response).to redirect_to post
      end
    end

    context 'with forbidden attributes' do
      before do
        allow(post).to receive(:update).and_return true
        allow(user).to receive_message_chain(:posts, :find).and_return post
        allow(controller).to receive(:current_user).and_return user
      end

      it 'generates ParameterMissing error without post params' do
        expect { put :update, id: post.id }.to raise_error(ActionController::ParameterMissing)
      end

      it 'filters forbidden params' do
        expect(post).to receive(:update).with(post_params)
        put :update, id: post.id, post: post_params.merge(user_id: 1)
      end
    end

    context 'with invalid attributes' do
      before do
        allow(post).to receive(:update).and_return false
        allow(user).to receive_message_chain(:posts, :find).and_return post
        allow(controller).to receive(:current_user).and_return user
      end

      it 'sends error flash' do
        put :update, id: post.id, post: post_params
        expect(flash[:error]).to eq 'Could not save post.'
      end

      it 'renders :edit template' do
        put :update, id: post.id, post: post_params
        expect(response).to render_template :edit
      end
    end
  end
end
```

---

# The End

<br>

[Go to Table of Contents](/)
