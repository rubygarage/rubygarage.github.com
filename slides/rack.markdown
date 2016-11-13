---
layout: slide
title:  Rack
---

# Rack

`Rack` provides a minimal interface between webservers supporting Ruby and Ruby frameworks. This
might seem a fairly simple thing, but it gives us a lot of power. One of the things it enables is
Rack Middleware which is a filter that can be used to intercept a request and alter the response
as a request is made to an application. 

To use `Rack`, provide an `app`: an object that responds to the call method, taking the environment
hash as a parameter, and returning an Array with three elements:

- The HTTP response code
- A Hash of headers
- The response body, which must respond to each

<br>

[Go to Table of Contents](/)

---

# Init enviropment

Create gemset

```bash
$ rvm use ruby-2.1.2@rack --create
```

Install Rack

```bash
$ gem install rack
```

Create Application

```bash
$ mkdir racker
$ cd racker/
```

---

# Config.ru file

config.ru <!-- .element: class="filename" -->

```ruby
class Racker
  def call(env)
    [200, {'Content-Type' => 'text/plain'}, ['Something happens!']]
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

# Response

config.ru <!-- .element: class="filename" -->

```ruby
class Racker
  def call(env)
    Rack::Response.new('We use Rack::Response! Yay!')
  end
end

run Racker.new
```

```sh
$ rackup
```

```sh
$ curl http://localhost:9292
We use Rack::Response! Yay!
```

---

# Just make it useful

config.ru <!-- .element: class="filename" -->

```ruby
require './lib/racker'
run Racker.new
```

lib/racker.rb <!-- .element: class="filename" -->

```ruby
require 'erb'

class Racker
  def call(env)
    Rack::Response.new(render('index.html.erb'))
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
```

--

lib/views/index.html.erb <!-- .element: class="filename" -->

```html
<!DOCTYPE html>
<html>
  <head>
    <title>WEB page</title>
  </head>
  <body>
    <div id='container'>
      <h1>We can load HTML! Wow!</h1>
    </div>
  </body>
</html>
```

```bash
$ rackup
```

```bash
$ curl http://localhost:9292

<!DOCTYPE html>
<html>
  <head>
    <title>WEB page</title>
  </head>
  <body>
    <div id='container'>
      <h1>We can load HTML! Wow!</h1>
    </div>
  </body>
</html>
```

---

# Request

lib/racker.rb <!-- .element: class="filename" -->

```ruby
require 'erb'

class Racker
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    else Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
```

--

```bash
$ rackup
```

```bash
$ curl http://localhost:9292
<!DOCTYPE html>
<html>
  <head>
    <title>WEB page</title>
  </head>
  <body>
    <div id='container'>
      <h1>We can load HTML! Wow!</h1>
    </div>
  </body>
</html>
```

```bash
$ curl http://localhost:9292/page
Not Found
```

---

# Just do it a little complicated

config.ru <!-- .element: class="filename" -->

```ruby
require './lib/racker'
run Racker
```

--

lib/racker.rb <!-- .element: class="filename" -->

```ruby
require 'erb'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    when '/update_word'
      Rack::Response.new do |response|
        response.set_cookie('word', @request.params['word'])
        response.redirect('/')
      end
    else Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def word
    @request.cookies['word'] || 'Nothing'
  end
end
```

--

lib/views/index.html.erb <!-- .element: class="filename" -->

```html
<!DOCTYPE html>
<html>
  <head>
    <title>WEB page</title>
  </head>
  <body>
    <div id="container">
      <h1>You said '<%= word %>'</h1>
      <p>Say something new</p>
      <form method="post" action="/update_word">
        <input name="word" type="text">
        <input type="submit" value="Say!">
      </form>
    </div>
  </body>
</html>
```

--

## rackup

```bash
$ rackup
```

Go to http://localhost:9292

![](/assets/images/rack/form.png)

--

# After submit

![](/assets/images/rack/form-2.png)

---

## Use middleware

config.ru <!-- .element: class="filename" -->
```ruby
require './lib/racker'

use Rack::Static, :urls => ['/stylesheets'], :root => 'public'
run Racker
```

--

lib/views/index.html.erb <!-- .element: class="filename" -->
```html
<!DOCTYPE html>
<html>
  <head>
    <title>WEB page</title>
    <link rel="stylesheet" href="/stylesheets/application.css" type="text/css">
  </head>
  <body>
    <div id="container">
      <h1>You said '<%= word %>'</h1>
      <p>Say somthing new</p>
      <form method="post" action="/update_word">
        <input name="word" type="text">
        <input type="submit" value="Say!">
      </form>
    </div>
  </body>
</html>
```

--

public/stylesheets/application.css <!-- .element: class="filename" -->
```css
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

--

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

config.ru <!-- .element: class="filename" -->
```ruby
# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
```

--

config/environment.rb <!-- .element: class="filename" -->
```ruby
# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
```

--

config/application.rb <!-- .element: class="filename" -->
```ruby
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestRailsRack
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
 
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
 
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
```

--

config/boot.rb <!-- .element: class="filename" -->
```ruby
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
```

---

## Rails rack middleware

```bash
$ rake middleware
use Rack::Sendfile
use ActionDispatch::Static
use Rack::Lock
use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007fcffbc69418>
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

---

# The End

<br>

[Go to Table of Contents](/)
