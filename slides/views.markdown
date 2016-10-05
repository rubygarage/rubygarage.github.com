---
layout: slide
title:  Views
---

# View

Action View is the V  in MVC. View responsible for displaying data. It doesn't make any logic
operations. Only displaying data.

![](/assets/images/mvc.png)

---

## Responses
From the controller's point of view, there are three ways to create an HTTP response:
* Call render to create a full response to send back to the browser
* Call redirect_to to send an HTTP redirect status code to the browser
* Call head to create a response consisting solely of HTTP headers to send back to the browser

---

## Default rendering
config/routes.rb
```ruby
Blog::Application.routes.draw do
resources :posts
end
```
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## .erb
app/views/posts/index.html.erb
```ruby
Listing posts
Title
Text
&lt;% @posts.each do |post| %&gt;
&lt;%= post.title %&gt;
&lt;%= post.text %&gt;
&lt;%= link_to 'Show', post %&gt;
&lt;%= link_to 'Edit', edit_post_path(post) %&gt;
&lt;%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %&gt;
&lt;% end %&gt;
```

---

## .jbuilder
app/views/posts/index.json.jbuilder
```ruby
json.array!(@posts) do |post|
json.extract! post, :id, :title, :text
json.url post_url(post, format: :json)
end
```
see [jbuilder docs][1]

---

## ActionController::Base#render method
In most cases, the ActionController::Base#render method does the heavy lifting of rendering your application's content
for use by a browser. There are a variety of ways to customize the behavior of render. You can render the default view
for a Rails template, or a specific template, or a file, or inline code, or nothing at all. You can render text, JSON,
or XML. You can specify the content type or HTTP status of the rendered response as well.
## Rendering Nothing
```ruby
def index
@posts = Post.all
render nothing: true
end
```
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

---

## Rendering an Action's Template from Another Controller
```ruby
def show
@post = Post.find(params[:id])
render 'posts/show'
#render template: "posts/show"
end
```
## Rendering an Arbitrary File
```ruby
def show
@post = Post.find(params[:id])
render '/var/www/blog/app/views/posts/show'
end
```
## Rendering an inline code
```ruby
def index
@posts = Post.all
render inline: "&lt;%= p.title %&gt;"
end
```
## Rendering a string
```ruby
def index
@posts = Post.all
render plain: "Ok"
end
```
## Rendering a string in the current layout
.txt.erb extension should be used for layout
```ruby
def index
@posts = Post.all
render plain: "Ok", layout: true
end
```

---

## Rendering Format
```ruby
def index
@posts = Post.all
respond_to do |format|
format.html {render html: "Count #{@posts.length}".html_safe}
format.json {render json: @posts}
format.xml {render xml: @posts}
format.js {render js: "alert('Count #{@posts.length}');"}
end
end
```
to_json, to_xml methods
## Rendering raw data
```ruby
render body: "raw"
```

---

## Render
```ruby
def update
@post = Post.find(params[:id])
if @post.update(params[:post])
redirect_to @post, notice: "Past was successfully updated"
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
## The :status option
```ruby
render status: 404          # by code
render status: :not_found   # by symbol
```
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
## The :layout option
```ruby
def show
@post = Post.find(params[:id])
render template: 'pages/post', layout: 'post'
end
```
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
ApplicationController.render inline: ''
# render partial
PostsController.render :_post, locals: { post: Post.last }
#render json
PostsController.render json: Post.all
```
#### Assigning variables
```ruby
ApplicationController.render(
assigns: { post: Post.first },
inline: ''
)
```
#### Request environment
```ruby
renderer = ApplicationController.renderer.new(
http_host: 'best_post.host',
https:      true
)
renderer.render inline: ''
# => 'https://best_post.host/posts'
```

---

## redirect_to
```ruby
redirect_to photos_url
```
```ruby
redirect_back(fallback_location: root_path)
```
```ruby
redirect_to photos_path, status: 301 #status can be both numeric or symbolic
```
## render and redirect_to difference
```ruby
def index
@post = Post.all
end
def show
@post = Post.find_by(id: params[:id])
if @post.nil?
render action: "index"
end
end
```
render :action doesn't run any code in the target action, so nothing will set up the @posts variable that the index
view will probably require.
```ruby
def index
@post = Post.all
end
def show
@post = Post.find_by(id: params[:id])
if @post.nil?
redirect_to action: :index
end
end
```
fresh request for the index page will be done and @posts variable will be set up
```ruby
def index
@posts = Book.all
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

## Layout
app/controllers/posts_controller.rb
```ruby
class PostsController
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Layout
app/controllers/posts_controller.rb
```ruby
class PostsController
app/controllers/posts_controller.rb
```ruby
class PostsController
app/controllers/posts_controller.rb
```ruby
class PostsController
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Layout inheritance
app/controllers/application_controller.rb
```ruby
class ApplicationController
app/controllers/posts_controller.rb
```ruby
class PostsController
app/controllers/posts_controller.rb
```ruby
class ItemsController

---

## Avoiding Double Render Errors
app/controllers/posts_controller.rb
```ruby
def show
@post = Post.find(params[:id])
if @post.archived?
render action: "archived"
end
render action: "updated"
end
```
app/controllers/posts_controller.rb
```ruby
def show
@post = Post.find(params[:id])
if @post.archived?
render action: "archived" and return
end
render action: "updated"
end
```
app/controllers/posts_controller.rb
```ruby
def show
@post = Post.find(params[:id])
if @post.archived?
render action: "archived"
end
end
```

---

## head
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
### Linking to Feeds
```ruby
```
#### Options
* `\:rel` specifies the rel value in the link. The default value is "alternate".
* `\:type` specifies an explicit MIME type. Rails will generate an appropriate MIME type automatically.
* `\:title` specifies the title of the link. The default value is the uppercase :type value, for example, "ATOM" or
"RSS".
### Linking to JavaScript Files
```ruby
```
#### Paths
/assets/javascripts/
/public/javascripts/ (for older versions)
#### Files can be placed into `javascripts` directory inside:
* app/assets
* lib/assets
* vendor/assets
### Linking to CSS Files
```ruby
```
by default `\:rel` is 'stylesheet' and `\:media` is 'screen'
#### Paths
/assets/stylesheets/
#### Files can be placed into `stylesheets` inside:
* app/assets
* lib/assets
* vendor/assets
### Linking to images
#### Paths
public/images/
```ruby
```
### Linking to videos
#### Paths
public/videos/
```ruby
```
```ruby
```
#### Options
* `poster: "image_name.png"` provides an image to put in place of the video before it starts playing
* `autoplay: true` starts playing the video on page load
* `loop: true` loops the video once it gets to the end
* `controls: true` provides browser supplied controls for the user to interact with the video
* `autobuffer: true` the video will pre load the file for the user on page load
###  Linking to audio files
#### Paths
public/audios/
```ruby
```
#### Options
* `autoplay: true` starts playing the audio on page load
* `controls: true` provides browser supplied controls for the user to interact with the audio
* `autobuffer: true` the audio will pre load the file for the user on page load

---

## Yield
app/views/layouts/application.html.erb
```ruby
```

---

## Content for
```ruby
Post page
Hello, It is my first post!
```
```ruby
Post page
Hello, It is my first post!
```

---

## Partials
```ruby
Post contains:
Search form:
```
## Locals
```ruby
```
```ruby
```
```ruby
```
Every partial also has a local variable with the same name as the partial (minus the underscore). Object can be passed
in to this local variable via the :object option
```ruby
```
If you have an instance of a model to render into a partial, you can use a shorthand syntax. Assuming that you have
_post.html.erb partial
```ruby
```

---

## Collection
app/views/posts/index.html.erb
```ruby
Posts
Name
Title
Content
&lt;%= render partial: "post", collection: @posts %&gt;
```
app/views/posts/_post.html.erb
```ruby
&lt;%= post.name %&gt;
&lt;%= post.title %&gt;
&lt;%= post.content %&gt;
```
```ruby
```
Rails will try to determine partial name from variable name. _post.html.erb and _user.html.erb will be used
```ruby
```
```ruby
```
```ruby
```
```ruby
```
```ruby
```
## Spacer template
```ruby
```

---

## FormTagHelper
Provides a number of methods for creating form tags that don't rely on an Active Record object assigned to the
template like FormHelper does. Instead, names and values should be provided manually.
form_tag, label_tag, text_field_tag, hidden_field_tag, submit_tag
```ruby
```
```ruby
Search for:
```
You can find more details [ here][2]

---

## FormHelper
### Form for
```ruby
&lt;%= pluralize(@post.errors.count, "error") %&gt;
&lt;% @post.errors.full_messages.each do |msg| %&gt;
&lt;%= msg %&gt;
&lt;% end %&gt;
&lt;%= f.label :name %&gt;
&lt;%= f.text_field :name %&gt;
&lt;%= f.label :title %&gt;
&lt;%= f.text_field :title %&gt;
&lt;%= f.label :content %&gt;
&lt;%= f.text_area :content %&gt;
&lt;%= f.submit %&gt;
```

---

## Nested attributes
app/modals/post.rb
```ruby
class Post
app/views/posts/_form.html.erb
```ruby
&lt;%= post_form.label :title %&gt;
&lt;%= post_form.text_field :title %&gt;
Comments
&lt;%= post_form.fields_for :comments do |comment_form| %&gt;
&lt;%= comment_form.label :text %&gt;
&lt;%= comment_form.text_field :text %&gt;
&lt;%- end %&gt;
&lt;%= post_form.label :content %&gt;
&lt;%= post_form.text_area :content %&gt;
&lt;%= post_form.submit %&gt;
```

---

## Nested attributes
```ruby
Title
Comments
Text
Text
Text
Content
Some string with with sense
```

---

## Testing views
spec/views/posts/index_spec.rb
```ruby
describe "posts/index.html.erb" do
it "renders _post partial for each post" do
assign(:posts, [stub_model(Post), stub_model(Post)])
render
view.should render_template(partial: "_post", count: 2)
end
end
```
app/views/posts/index.html.erb
```ruby
Listing posts
Name
Title
Content
&lt;%= render @posts %&gt;
```
spec/views/posts/show_spec.rb
```ruby
describe "posts/show.html.erb" do
it "displays the post's title" do
assign(:post, stub_model(Post, title: "Cool title"))
render
expect(rendered).to contain("Cool title")
end
end
```
app/views/posts/show.html.erb
```ruby
&lt;%= @post.title %&gt;
```
### Capybara
spec/spec_helper.rb
```ruby
require 'capybara/rspec'
```
spec/views/posts/show_spec.rb
```ruby
require 'spec_helper'
describe "posts/index.html.erb" do
it "has posts list selector" do
assign(:posts, [stub_model(Post), stub_model(Post)])
render
expect(rendered).to have_selector('#posts')
end
end
```
app/views/posts/index.html.erb
```ruby
Listing posts
Name
Title
Content
&lt;%= render @posts %&gt;
```

---

## Helpers
app/helpers/application_helper.rb
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
@title_parts
app/views/posts/show.html.erb
```ruby
```
app/views/layouts/application.html.erb
```ruby
```
HTML
```ruby
pr-text-sf
```

---

## helper_method
app/controllers/application_controller.rb
```ruby
class ApplicationController

---

## Testing helpers
spec/helpers/posts_spec.rb
```ruby
require 'spec_helper'
describe PostsHelper do
describe "#post_title" do
it "should return post title" do
post = stub_model(Post, title: 'New age of IT')
post_title(post).should == 'New age of IT'
end
end
end
```
app/helpers/posts_spec.rb
```ruby
module PostsHelper
def post_title(post)
post.title
end
end
```

---

## Haml
The principles of Haml:
* Markup should be beautiful
* Markup should be DRY
* Markup should be indented
* Structure should be clear

---

## Haml
views/posts/post.html.erb
```ruby
&lt;%= post.name %&gt;
&lt;%= post.title %&gt;
&lt;%= post.content %&gt;
```
views/posts/post.html.haml
```ruby
%tr
%td= post.name
%td= post.title
%td= post.content
```
REMEMBER: Do not use spaces between tag and '='
## Attributes
views/posts/post.html.haml
```ruby
%tr{'my-attr'=> 'some value', normal: 'other value'}
%td= post.name
%td= post.title
%td= post.content
```
## Boolean attributes
Haml
```ruby
%input{selected: true}
```
HTML
```ruby
```
Haml
```ruby
%input{selected: false}
```
HTML
```ruby
```
## Inserting JavaScript
```ruby
%script{type: 'text/javascript'}
console.log('script was executed');
```

---

## Class and ID: . and \#
Haml
```ruby
%div#elems
%span.green= "Green Label"
%p.firstclass.secondclass
```
HTML
```ruby
Green Label
```

---

## Haml vs HTML
Haml
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
%li Three​​​
```
HTML
```ruby
Some Headline
Lorem ipsum doller your mom...
One
Two
Three
Some Headline
Lorem ipsum doller your mom...
One
Two
Three​​​
```
[1]: https://github.com/rails/jbuilder
[2]: http://api.rubyonrails.org/classes/ActionView/Helpers/FormTagHelper.html
