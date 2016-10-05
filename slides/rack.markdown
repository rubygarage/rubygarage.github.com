---
layout: slide
title:  Rack
---

# Rack
`Rack` provides a minimal interface between webservers supporting Ruby and Ruby frameworks. This might seem a fairly
simple thing, but it gives us a lot of power. One of the things it enables is Rack Middleware which is a filter that
can be used to intercept a request and alter the response as a request is made to an application.
To use Rack, provide an "app": an object that responds to the call method, taking the environment hash as a
parameter, and returning an Array with three elements:
* The HTTP response code
* A Hash of headers
* The response body, which must respond to each

---

## Init enviropment
### Create gemset
```bash
rvm use ruby-2.1.2@rack --create
```
### Install Rack
```bash
gem install rack
```
### Create Application
```bash
mkdir racker
cd racker/
```

---

## Config.ru file
config.ru
```ruby
class Racker
def call(env)
[200, {"Content-Type" => "text/plain"}, ["Something happens!"]]
end
end
run Racker.new
```
```bash
$ rackup
```
```bash
$ curl http://localhost:9292
Something happens!
```

---

## Response
config.ru
```ruby
class Racker
def call(env)
Rack::Response.new("We use Rack::Response! Yay!")
end
end
run Racker.new
```
```bash
$ rackup
```
```bash
$ curl http://localhost:9292
We use Rack::Response! Yay!
```

---

## Just make it useful
config.ru
```ruby
require "./lib/racker"
run Racker.new
```
lib/racker.rb
```ruby
require "erb"
class Racker
def call(env)
Rack::Response.new(render("index.html.erb"))
end
def render(template)
path = File.expand_path("../views/#{template}", __FILE__)
ERB.new(File.read(path)).result(binding)
end
end
```
lib/views/index.html.erb
```ruby
WEB page
We can load HTML! Wow!
```
```bash
$ rackup
```
```bash
$ curl http://localhost:9292
WEB page
We can load HTML! Wow!
```

---

## Request
lib/racker.rb
```ruby
require "erb"
class Racker
def call(env)
request = Rack::Request.new(env)
case request.path
when "/" then Rack::Response.new(render("index.html.erb"))
else Rack::Response.new("Not Found", 404)
end
end
def render(template)
path = File.expand_path("../views/#{template}", __FILE__)
ERB.new(File.read(path)).result(binding)
end
end
```
```bash
$ rackup
```
```bash
$ curl http://localhost:9292
WEB page
We can load HTML! Wow!
```
```bash
$ curl http://localhost:9292/page
Not Found
```

---

## Just do it a little complicated
config.ru
```ruby
require "./lib/racker"
run Racker
```
lib/racker.rb
```ruby
require "erb"
class Racker
def self.call(env)
new(env).response.finish
end
def initialize(env)
@request = Rack::Request.new(env)
end
def response
case @request.path
when "/" then Rack::Response.new(render("index.html.erb"))
when "/update_word"
Rack::Response.new do |response|
response.set_cookie("word", @request.params["word"])
response.redirect("/")
end
else Rack::Response.new("Not Found", 404)
end
end
def render(template)
path = File.expand_path("../views/#{template}", __FILE__)
ERB.new(File.read(path)).result(binding)
end
def word
@request.cookies["word"] || "Nothing"
end
end
```
lib/views/index.html.erb
```ruby
WEB page
You said '&lt;%= word %&gt;'
Say somthing new
```
```bash
$ rackup
```
### Go to http://localhost:9292
#### You said 'Nothing'
Say somthing new
### After submit
#### You said 'Hello!'
Say somthing new

---

## Use middleware
config.ru
```ruby
require "./lib/racker"
use Rack::Static, :urls => ["/stylesheets"], :root => "public"
run Racker
```
lib/views/index.html.erb
```ruby
WEB page
You said '&lt;%= word %&gt;'
Say somthing new
```
public/stylesheets/application.css
```ruby
body {
background-color: #4B7399;
font-family: Verdana;
font-size: 14px;
}
#container {
width: 75%;
margin: 0 auto;
background-color: #FFF;
padding: 20px 40px;
border: solid 1px black;
margin-top: 20px;
}
a {
color: #0000FF;
}
```
```bash
$ rackup
```
```bash
$ curl http://localhost:9292/stylesheets/application.css
body {
background-color: #4B7399;
font-family: Verdana;
font-size: 14px;
}
#container {
width: 75%;
margin: 0 auto;
background-color: #FFF;
padding: 20px 40px;
border: solid 1px black;
margin-top: 20px;
}
a {
color: #0000FF;
}
```
Url to Rack::Static - https://github.com/rack/rack/blob/master/lib/rack/static.rb
Url to Rack::Builder - https://github.com/rack/rack/blob/master/lib/rack/builder.rb

---

## In to Rails
config.ru
```ruby
# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
```
config/environment.rb
```ruby
# Load the Rails application.
require File.expand_path('../application', __FILE__)
# Initialize the Rails application.
Rails.application.initialize!
```
config/application.rb
```ruby
require File.expand_path('../boot', __FILE__)
require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module TestRailsRack
class Application
config/boot.rb
```ruby
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
```

---

## Rails rack middleware
```bash
rake middleware
use Rack::Sendfile
use ActionDispatch::Static
use Rack::Lock
use #
use Rack::Runtime
use Rack::MethodOverride
use ActionDispatch::RequestId
use Rails::Rack::Logger
use ActionDispatch::ShowExceptions
use ActionDispatch::DebugExceptions
use ActionDispatch::RemoteIp
use ActionDispatch::Reloader
use ActionDispatch::Callbacks
use ActiveRecord::Migration::CheckPending
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use ActiveRecord::QueryCache
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore
use ActionDispatch::Flash
use ActionDispatch::ParamsParser
use Rack::Head
use Rack::ConditionalGet
use Rack::ETag
run TestRailsRack::Application.routes
```
Url to Rails on Rack guides - http://guides.rubyonrails.org/rails_on_rack.html
