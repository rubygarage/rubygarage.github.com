---
layout: slide
title:  Views
---

# View

---

# Action View

`Action View` is the `V`  in MVC. View responsible for displaying data. It doesn't make any logic
operations. Only displaying data.

--

![](/assets/images/mvc.svg)

---

# Responses

From the controller's point of view, there are three ways to create an HTTP response:
- Call render to create a full response to send back to the browser
- Call redirect_to to send an HTTP redirect status code to the browser
- Call head to create a response consisting solely of HTTP headers to send back to the browser

---

# Default rendering

config/routes.rb <!-- .element: class="filename" -->

```ruby
Blog::Application.routes.draw do
  resources :posts
end
```

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController<ApplicationController
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # app/views/posts/index.html.erb
      format.json # app/views/posts/index.json.jbuilder
    end
  end
end

```

---

## .erb

app/views/posts/index.html.erb <!-- .element: class="filename" -->

```html
<h1>Listing posts</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Text</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>

  <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td><%= post.title %></td>
        <td><%= post.text %></td>
        <td><%= link_to 'Show', post %></td>
        <td><%= link_to 'Edit', edit_post_path(post) %></td>
        <td><%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Post', new_post_path %>
```

---

## .jbuilder

app/views/posts/index.json.jbuilder <!-- .element: class="filename" -->

```ruby
json.array!(@posts) do |post|
  json.extract! post, :id, :title, :text
  json.url post_url(post, format: :json)
end
```

see [jbuilder docs](https://github.com/rails/jbuilder)

---

## ActionController::Base#render method

In most cases, the `ActionController::Base#render` method does the heavy lifting of rendering your application's content
for use by a browser. There are a variety of ways to customize the behavior of render. You can render the default view
for a Rails template, or a specific template, or a file, or inline code, or nothing at all. You can render text, JSON,
or XML. You can specify the content type or HTTP status of the rendered response as well.

--

## Rendering Nothing

```ruby
def index
  @posts = Post.all

  render nothing: true
end
```

--

## Rendering an Action's View

```ruby
def update
  @post = Post.find(params[:id])

  if @post.update(params[:post])
    redirect_to @post, notice: 'Post was successfully updated.'
  else
    render :edit
    #render 'edit'
    #render action: 'edit'
  end
end
```

--

## Rendering an Action's Template from Another Controller

```ruby
def show
  @post = Post.find(params[:id])

  render 'posts/show'
  #render template: 'posts/show'
end
```

--

## Rendering an Arbitrary File

```ruby
def show
  @post = Post.find(params[:id])

  render '/var/www/blog/app/views/posts/show'
end
```

--

## Rendering an inline code

```ruby
def index
  @posts = Post.all

  render inline: "<% @posts.each do |p| %><p><%= p.title %></p><% end %>"
end
```

--

## Rendering a string

```ruby
def index
  @posts = Post.all

  render plain: 'Ok'
end
```

--

## Rendering a string in the current layout

`.txt.erb` extension should be used for layout

```ruby
def index
  @posts = Post.all

  render plain: 'Ok', layout: true
end
```

--

## Rendering Format

```ruby
def index
  @posts = Post.all

  respond_to do |format|
    format.html {render html: "Count <strong>#{@posts.length}</strong>".html_safe}
    format.json {render json: @posts}
    format.xml {render xml: @posts}
    format.js {render js: "alert('Count #{@posts.length}');"}
  end
end
```

`to_json`, `to_xml` methods

## Rendering raw data

```ruby
render body: 'raw'
```

--

## Render

```ruby
def update
  @post = Post.find(params[:id])

  if @post.update(params[:post])
    redirect_to @post, notice: 'Past was successfully updated'
  else
    render :edit
    render action: :edit
    render 'edit'
    render 'edit.html.erb'
    render action: 'edit'
    render action: 'edit.html.erb'
    render 'posts/edit'
    render 'posts/edit.html.erb'
    render template: 'posts/edit'
    render template: 'posts/edit.html.erb'
    render '/path/to/rails/app/views/posts/edit'
    render '/path/to/rails/app/views/posts/edit.html.erb'
    render file: '/path/to/rails/app/views/posts/edit'
    render file: '/path/to/rails/app/views/posts/edit.html.erb'
  end
end
```

---

## The :content_type option

```ruby
def index
  @post = Post.all

  respond_to do |format|
    format.html
    format.xml do
      render template: 'posts/rss_list', content_type: 'application/rss'
    end
  end
end
```

--

## The :status option

```ruby
render status: 404          # by code
render status: :not_found   # by symbol
```

--

## The :location option

```ruby
def index
  @post = Post.all

  respond_to do |format|
    format.html
    format.xml do
      render xml: @posts, location: posts_url
    end
  end
end
```

--

## The :layout option

```ruby
def show
  @post = Post.find(params[:id])

  render template: 'pages/post', layout: 'post'
end
```

--

## The :formats option

```ruby
render formats: [:json, :xml]
#render formats: :xml
```

---

## Rendering outside of actions

Rails 5 only!

```ruby
# render template
ApplicationController.render 'templates/name'

# render action
PostController.render :index

# render file
ApplicationController.render file: 'path'

# render inline
ApplicationController.render inline: '<%= posts_url %>'

# render partial
PostsController.render :_post, locals: { post: Post.last }

#render json
PostsController.render json: Post.all
```

--

### Assigning variables

```ruby
ApplicationController.render(
  assigns: { post: Post.first },
  inline: ''
)
```

### Request environment

```ruby
renderer = ApplicationController.renderer.new(
  http_host: 'best_post.host',
  https:      true
)

renderer.render inline: '<%= posts_url %>'
# => 'https://best_post.host/posts'
```

---

# redirect_to

```ruby
redirect_to photos_url
```

```ruby
redirect_back(fallback_location: root_path)
```

```ruby
redirect_to photos_path, status: 301 #status can be both numeric or symbolic
```

--

## `render` and `redirect_to` difference

```ruby
def index
  @posts = Post.all
end

def show
  @post = Post.find_by(id: params[:id])

  if @post.nil?
    render action: 'index'
  end
end
```

--

render :action doesn't run any code in the target action, so nothing will set up the @posts variable that the index
view will probably require.

```ruby
def index
  @posts = Post.all
end

def show
  @post = Post.find_by(id: params[:id])

  if @post.nil?
    redirect_to action: :index
  end
end
```

--

fresh request for the index page will be done and @posts variable will be set up

```ruby
def index
  @posts = Post.all
end

def show
  @post = Post.find_by(id: params[:id])

  if @post.nil?
    @posts = Post.all
    flash.now[:alert] = "Your post was not found"
    render "index"
  end
end
```

---

# Layout

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout 'post'

  def index
    @posts = Post.all
  end
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout :posts_layout

  def index
    @posts = Post.all
  end

  private

  def posts_layout
    current_user.admin? ? 'admin' : 'post'
  end
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout :layout_name

  private

  def layout_name
    @current_user.admin? ? 'admin' : 'application'
  end
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout Proc.new{ |controller| controller.request.xhr? ? 'popup' : 'application'}
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout 'post', except: [:index, :create]
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout nil
end
```

---

# Layout inheritance

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  layout 'application'
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  layout 'post'
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class ItemsController < PostsController
  layout false

  def show
    @item = Item.find(params[:id])
  end

  def index
    @items = Item.old
    render layout: 'item'
  end
  # ...
end
```

---

## Avoiding Double Render Errors

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
def show
  @post = Post.find(params[:id])

  if @post.archived?
    render action: 'archived'
  end

  render action: 'updated'
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
def show
  @post = Post.find(params[:id])

  if @post.archived?
    render action: 'archived' and return
  end

  render action: 'updated'
end
```

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
def show
  @post = Post.find(params[:id])

  if @post.archived?
    render action: 'archived'
  end
end
```

---

# head

```ruby
head :bad_request
```

```ruby
HTTP/1.1 400 Bad Request
Connection: close
Date: Sun, 24 Jan 2010 12:15:53 GMT
Transfer-Encoding: chunked
Content-Type: text/html; charset=utf-8
X-Runtime: 0.013483
Set-Cookie: _blog_session=...snip...; path=/; HttpOnly
Cache-Control: no-cache
```

```ruby
head :created, location: post_path(@post)
```

```ruby
HTTP/1.1 201 Created
Connection: close
Date: Sun, 24 Jan 2010 12:16:44 GMT
Transfer-Encoding: chunked
Location: /posts/1
Content-Type: text/html; charset=utf-8
X-Runtime: 0.083496
Set-Cookie: _blog_session=...snip...; path=/; HttpOnly
Cache-Control: no-cache
```

---

## Layouts structuring

* Asset tags
* `yield` and `content_for`
* Partials

---

## Asset tags

* auto_discovery_link_tag
* javascript_include_tag
* stylesheet_link_tag
* image_tag
* video_tag
* audio_tag

--

## Linking to Feeds

```html
<%= auto_discovery_link_tag(:rss, {action: 'feed'}, {title: 'RSS Feed'}) %>
```

#### Options
* `:rel` specifies the rel value in the link. The default value is "alternate".
* `:type` specifies an explicit MIME type. Rails will generate an appropriate MIME type automatically.
* `:title` specifies the title of the link. The default value is the uppercase :type value, for example, "ATOM" or
"RSS".

--

## Linking to JavaScript Files
```html
<%= javascript_include_tag 'application' %>
<!-- '/assets/application.js' -->
<%= javascript_include_tag 'application', 'posts' %>
<%= javascript_include_tag 'http://example.com/application.js' %>
```

#### Paths

```
/assets/javascripts/
```

```
/public/javascripts/ (for older versions)
```

#### Files can be placed into `javascripts` directory inside:

```
app/assets
```

```
lib/assets
```

```
vendor/assets
```

--

## Linking to CSS Files

```html
<%= stylesheet_link_tag 'application' %>
<!-- 'app/assets/stylesheets/application.css' -->
<%= stylesheet_link_tag 'application', 'posts' %>
<%= stylesheet_link_tag 'application', 'posts/comments' %>
<!-- 'app/assets/stylesheets/posts/comments.css' -->
<%= stylesheet_link_tag 'http://example.com/application.css' %>
<!-- can accept options :rel and :media -->
<%=  stylesheet_link_tag 'application_tablet', media: 'tablet' %>
```

by default `:rel` is 'stylesheet' and `:media` is 'screen'

#### Paths

```
/assets/stylesheets/
```

#### Files can be placed into `stylesheets` inside:

```
app/assets
```

```
lib/assets
```

```
vendor/assets
```

--

## Linking to images

#### Paths

```
public/images/
```

```html
<%= image_tag 'header.png' %>
<%= image_tag 'icons/delete.gif' %>
<%= image_tag 'icons/delete.gif', {height: 45} %>
<%= image_tag 'home.gif' %>
<!-- ads alt - capitalized file name without extension -->
<%= image_tag 'home.gif', alt: 'Home' %>
<%= image_tag 'home.gif', size: '50x20' %>
<%= image_tag 'home.gif', alt: 'Go Home', id: 'HomeImage', class: 'nav_bar' %>
<!-- possible options :class, :id or :name -->
<%=  stylesheet_link_tag 'application_tablet', media: 'tablet' %>
<!-- can accept options :rel and :media -->
```

--

## Linking to videos

#### Paths

```
public/videos/
```

```html
<%= video_tag 'movie.ogg' %>
<!-- result -->
< video src='/videos/movie.ogg' />
```

```html
<%= video_tag ['trailer.ogg', 'movie.ogg'] %>
<!-- result -->
<video>
  <source src='/videos/trailer.ogg'>
  <source src='/videos/movie.ogg'>
</video>
```

#### Options

* `poster: 'image_name.png'` provides an image to put in place of the video before it starts playing
* `autoplay: true` starts playing the video on page load
* `loop: true` loops the video once it gets to the end
* `controls: true` provides browser supplied controls for the user to interact with the video
* `autobuffer: true` the video will pre load the file for the user on page load

--

##  Linking to audio files

#### Paths

```
public/audios/
```

```html
<%= audio_tag 'music.mp3' %>
<%= audio_tag 'music/first_song.mp3' %>
```

#### Options
* `autoplay: true` starts playing the audio on page load
* `controls: true` provides browser supplied controls for the user to interact with the audio
* `autobuffer: true` the audio will pre load the file for the user on page load

---

# Yield

app/views/layouts/application.html.erb <!-- .element: class="filename" -->

```html
<html>
  <head>
    <%= yield :head %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

---

# Content for

```html
<% content_for :head do %>
  <title>Post page</title>
<% end %>
<p>Hello, It is my first post!</p>
```

```html
<html>
  <head>
    <title>Post page</title>
  </head>
  <body>
    <p>Hello, It is my first post!</p>
  </body>
</html>
```

---

# Partials

```html
<!-- views/posts/_form.html.erb -->
<% = render 'form' %>

<!-- views/shared/_menu.html.erb -->
<% = render 'shared/menu' %>

<!-- views/posts/_post.html.erb -->
<% = render @post %>

<!-- views/posts/index.html.erb -->
<%= render 'shared/search_filters', search: @q do |f| %>
  <p>
    Post contains: <%= f.text_field :post_contains %>
  </p>
<% end %>
<%= render partial: 'footer', layout: 'bar' %>

<!-- shared/_search_filters.html.erb -->
<%= form_for(@q) do |f| %>
  <h1>Search form:</h1>
  <fieldset>
    <%= yield f %>
  </fieldset>
  <p>
    <%= f.submit 'Search' %>
  </p>
<% end %>
```

---

# Locals

```html
<% = render partial: 'form', locals: {post: @post} %>
```

```html
<% = render 'form', post: @post %>
```

```html
<%= render @post, full: true %>

<!-- views/posts/_post.html.erb -->
<h2><%= post.title %></h2>

<% if local_assigns[:full] %>
  <%= simple_format post.text %>
<% else %>
  <%= truncate post.text %>
<% end %>
```

Every partial also has a local variable with the same name as the partial (minus the underscore). Object can be passed
in to this local variable via the :object option

```html
<%= render partial: 'post', object: @new_post %>
```

If you have an instance of a model to render into a partial, you can use a shorthand syntax. Assuming that you have
`_post.html.erb` partial

```html
<%= render @post %>
```

---

# Collection

app/views/posts/index.html.erb <!-- .element: class="filename" -->

```html
<h1>Posts<h1>
<table>
  <tr>
    <th>Name</th>
    <th>Title</th>
    <th>Content</th>
  </tr>
  <%= render partial: 'post', collection: @posts %>
</table>
```

app/views/posts/_post.html.erb <!-- .element: class="filename" -->

```html
<tr>
  <td><%= post.name %></td>
  <td><%= post.title %></td>
  <td><%= post.content %></td>
</tr>
```

```html
<%= render @posts %>
```

--

Rails will try to determine partial name from variable name. `_post.html.erb` and `_user.html.erb` will be used

```html
<%= render [post1, user1, post2, user2] %>
```

```html
<%= render(@posts) || 'There are no posts available.' %>
```

```html
<%= render partial: 'post', collection: @posts, as: :article %>
```

```html
<% =render partial: 'post', collection: @posts, as: :item, locals: { title: 'Post page' } %>
```

```html
<% =render partial: 'post', collection: @posts, layout: 'single_post_layout' %>
```

---

# Spacer template

```html
<%= render @posts, spacer_template: 'post_spacer' %>
```

---

# FormTagHelper

Provides a number of methods for creating form tags that don't rely on an Active Record object assigned to the
template like FormHelper does. Instead, names and values should be provided manually.

`form_tag`, `label_tag`, `text_field_tag`, `hidden_field_tag`, `submit_tag`

```html
<%= form_tag('/posts/search', method: 'get') do %>
  <%= label_tag(:q, 'Search for:') %>
  <%= text_field_tag(:q) %>
  <%= hidden_field_tag(:special_id, '11') %>
  <%= submit_tag("Search")
<% end %>
```

```html
<form accept-charset="UTF-8" action="/posts/search" method="get">
  <label for ="q"> Search for: </label>
  <input id ="q" name = "q" type = "text" />
  <input id ="special_id" name= "special_id" type = "hidden" value="11" />
  <input name = "commit" type ="submit" value= "Search" />
</form>
```

You can find more details [here](http://api.rubyonrails.org/classes/ActionView/Helpers/FormTagHelper.html)

---

# FormHelper

--

## Form for

```html
<%= form_for(@post) do |f| %>
  <% if @post.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@post.errors.count, 'error') %>
      <ul>
        <% @post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class = 'field'>
    <%= f.label :name %> <br />
    <%= f.text_field :name %>
  </div>

  <div class = 'field'>
    <%= f.label :title %> <br />
    <%= f.text_field :title %>
  </div>

  <div class = 'field'>
    <%= f.label :content %> <br />
    <%= f.text_area :content %>
  </div>

  <div class = 'actions'>
    <%= f.submit %>
  </div>
<% end %>
```

---

## Nested attributes

app/modals/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ActiveRecord::Base
  has_many :comments
  accepts_nested_attributes_for :comments
end
```

app/views/posts/_form.html.erb <!-- .element: class="filename" -->

```html
<%= form_for @post do |post_form| %>
  <div class = "field">
    <%= post_form.label :title %> <br/>
    <%= post_form.text_field :title %> <br/>
  </div>
  <div>
    Comments
    <%= post_form.fields_for :comments do |comment_form| %>
      <div class = "field">
        <%= comment_form.label :text %> <br />
        <%= comment_form.text_field :text %> <br />
      </div>
    <%- end %>
  </div>
  <div class ="field">
    <%= post_form.label :content %> <br />
    <%= post_form.text_area :content %> <br />
  </div>
  <div class = "actions">
    <%= post_form.submit %>
  </div>
<%- end %>
```

--

```html
<form  accept-charset ="UTF-8" action="/posts/2" class="edit_post" =" edit_post" method = "post">

  <div style ="margin:0;padding:0;display:inline">
    <input name="utf8" type="hidden" value="✓" />
    <input name="_method" type="hidden" value="put" />
    <input name="authenticity_token" type="hidden" value="IOTTvaKsTlk..." />
  </div>

  <div class="field">
    <label for="post_title"> Title</label><br />
    <input id="post_title" name="post[title]" size="30" type="text" value="Some cool title" />
  </div>

    Comments
      <div class="field">
        <label for="post_comments_attributes_0_text"> Text</label><br />
        <input id="post_comments_attributes_0_text" name="post[comments_attributes][0][text]" size="30" type="text" value="comment" />
      </div>
      <input id="post_comments_attributes_0_id" name="post[comments_attributes][0][id]" type="hidden" value ="1">

      <div class="field">
        <label for="post_comments_attributes_1_text"> Text</label><br />
        <input id="post_comments_attributes_1_text" name="post[comments_attributes][1][text]" size="30" type="text" value="comment" />
      </div>
      <input id="post_comments_attributes_1_id" name="post[comments_attributes][1][id]" type="hidden" value ="2">

      <div class="field">
        <label for="post_comments_attributes_2_text"> Text</label><br />
        <input id="post_comments_attributes_2_text" name="post[comments_attributes][2][text]" size="30" type="text" value="comment" />
      </div>
      <input id="post_comments_attributes_2_id" name="post[comments_attributes][2][id]" type="hidden" value ="3">

      <div class ="field">
        <label for="post_content">Content</label><br/>
        <textarea cols="40" id="post_content" name="post[content]" rows="20"> Some string with with sense</textarea>
      </div>
      <div class="actions">
        <input name="commit" type="submit" value="Update Post"/>
      </div>
```

---

# Testing views

spec/views/posts/index_spec.rb <!-- .element: class="filename" -->

```ruby
describe 'posts/index.html.erb' do
  it 'renders _post partial for each post' do
    assign(:posts, [stub_model(Post), stub_model(Post)])
    render
    view.should render_template(partial: '_post', count: 2)
  end
end
```

--

app/views/posts/index.html.erb <!-- .element: class="filename" -->

```html
<h1>Listing posts</h1>
<table>
  <tr>
    <th>Name</th>
    <th>Title</th>
    <th>Content</th>
  </tr>
  <%= render @posts %>
</table>
```

--

spec/views/posts/show_spec.rb <!-- .element: class="filename" -->

```ruby
describe 'posts/show.html.erb' do
  it "displays the post's title" do
    assign(:post, stub_model(Post, title: 'Cool title'))
    render
    expect(rendered).to contain('Cool title')
  end
end
```

app/views/posts/show.html.erb <!-- .element: class="filename" -->

```html
<h1><%= @post.title %></h1>
```

--

# Capybara

spec/spec_helper.rb <!-- .element: class="filename" -->

```ruby
require 'capybara/rspec'
```

spec/views/posts/show_spec.rb <!-- .element: class="filename" -->

```ruby
require 'spec_helper'

describe 'posts/index.html.erb' do
  it 'has posts list selector' do
    assign(:posts, [stub_model(Post), stub_model(Post)])
    render
    expect(rendered).to have_selector('#posts')
  end
end
```

app/views/posts/index.html.erb <!-- .element: class="filename" -->

```html
<h1>Listing posts</h1>
<table id="posts">
  <tr>
    <th>Name</th>
    <th>Title</th>
    <th>Content</th>
  </tr>
  <%= render @posts %>
</table>
```

---

# Helpers

app/helpers/application_helper.rb <!-- .element: class="filename" -->

```ruby
module ApplicationHelper
  #have title_tag in your head
  def title init_value
    @title_parts ||= []
    @title_parts.unshift init_value
    init_value
  end

  #This should be in the head
  def title_tag options ={}
    content_tag :title, get_title(options)
  end

  def get_title options ={}
    @title_parts ||= []
    @title_parts.unshift options[:prefix] unless options[:prefix].nil?
    @title_parts << options[:suffix] unless options[:suffix].nil?
    separator = options.fetch(:separator, ' - ')
    @title_parts.join(separator).html_safe
  end
end
```

--

app/views/posts/show.html.erb <!-- .element: class="filename" -->

```ruby
<% title("text") %>
```

app/views/layouts/application.html.erb <!-- .element: class="filename" -->

```ruby
<%= title_tag prefix: 'pr', suffix: 'sf', separator: '-' %>
```

HTML
```ruby
<title>
  pr-text-sf
</title>
```

---

# helper_method

app/controllers/application_controller.rb <!-- .element: class="filename" -->

```ruby
class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by_id(session[:current_user_id])
  end
end
```

---

# Testing helpers

spec/helpers/posts_spec.rb <!-- .element: class="filename" -->

```ruby
require 'spec_helper'

describe PostsHelper do
  describe '#post_title' do
    it 'should return post title' do
      post = stub_model(Post, title: 'New age of IT')
      post_title(post).should == 'New age of IT'
    end
  end
end
```

app/helpers/posts_spec.rb <!-- .element: class="filename" -->

```ruby
module PostsHelper
  def post_title(post)
    post.title
  end
end
```

---

# Haml

The principles of Haml:

* Markup should be beautiful
* Markup should be DRY
* Markup should be indented
* Structure should be clear

--

views/posts/post.html.erb <!-- .element: class="filename" -->

```html
<tr>
  <td><%= post.name %></td>
  <td><%= post.title %></td>
  <td><%= post.content %></td>
</tr>
```

views/posts/post.html.haml <!-- .element: class="filename" -->

```ruby
%tr
  %td= post.name
  %td= post.title
  %td= post.content
```

REMEMBER: Do not use spaces between tag and '='

--

## Attributes

views/posts/post.html.haml <!-- .element: class="filename" -->

```ruby
%tr{'my-attr'=> 'some value', normal: 'other value'}
  %td= post.name
  %td= post.title
  %td= post.content
```

--

## Boolean attributes

Haml

```ruby
%input{selected: true}
```

HTML

```html
<input selected = "selected">
```

Haml

```ruby
%input{selected: false}
```

HTML

```html
<input>
```

--

## Inserting JavaScript

```ruby
%script{type: 'text/javascript'}
  console.log('script was executed');
```

--

## Class and ID: . and \#

Haml

```ruby
%div#elems
  %span.green= 'Green Label'
  %p.firstclass.secondclass
```

HTML
```html
<div id="elems">
  <span class="green">Green Label</span>
  <p class="firstclass secondclass"></p>
</div>
```

---

# Haml vs HTML

--

## Haml

```ruby
#container
  .box
    %h2 Some Headline
    %p Lorem ipsum doller your mom...
    %ul.mainList
      %li One
      %li Two
      %li Three
  .box
    %h2 Some Headline
    %p Lorem ipsum doller your mom...
    %ul.mainList
      %li One
      %li Two
      %li Three
```

--

## HTML

```html
<div id='container'>
  <div class='box'>
    <h2>Some Headline</h2>
    <p>Lorem ipsum doller your mom...</p>
    <ul class='mainList'>
      <li>One</li>
      <li>Two</li>
      <li>Three</li>
    </ul>
  </div>
  <div class='box'>
    <h2>Some Headline</h2>
    <p>Lorem ipsum doller your mom...</p>
    <ul class='mainList'>
      <li>One</li>
      <li>Two</li>
      <li>Three</li>
    </ul>
  </div>
</div>
```

---

# The End
