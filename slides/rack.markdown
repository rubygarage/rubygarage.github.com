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

---

# Init enviropment

Create gemset

```bash
$ rvm use ruby-2.4.1@rack --create
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

# Rack Application

config.ru <!-- .element: class="filename" -->

```ruby
class Racker
  def call(env)
    [200, { 'Content-Type' => 'text/plain' }, ['Something happens!']]
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

# Rackup

`rackup` is a useful tool for running Rack applications,
which uses the `Rack::Builder` DSL to configure middleware and build up applications easily.

Rackup automatically figures out the environment it is run in,
and runs your application as FastCGI, CGI, or standalone with `Puma`, `Thin` or `WEBrick` from the same configuration.

To `rackup` the application we need to create a file with `.ru` file extension,
then drop our simple application inside it and use the rackup command line tool to start it.

rackup - https://github.com/rack/rack/blob/master/bin/rackup

Rack::Builder - https://github.com/rack/rack/blob/master/lib/rack/builder.rb

---

# Accepted `env` hash

```ruby
{
  "GATEWAY_INTERFACE"=>"CGI/1.1",
  "PATH_INFO"=>"/",
  "QUERY_STRING"=>"",
  "REMOTE_ADDR"=>"::1",
  "REMOTE_HOST"=>"::1",
  "REQUEST_METHOD"=>"GET",
  "REQUEST_URI"=>"http://localhost:9292/",
  "SCRIPT_NAME"=>"",
  "SERVER_NAME"=>"localhost",
  "SERVER_PORT"=>"9292",
  "SERVER_PROTOCOL"=>"HTTP/1.1",
  "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/2.3.2/2016-11-15)",
  "HTTP_HOST"=>"localhost:9292",
  "HTTP_CONNECTION"=>"keep-alive",
  "HTTP_UPGRADE_INSECURE_REQUESTS"=>"1",
  "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
  "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
  "HTTP_ACCEPT_ENCODING"=>"gzip, deflate, sdch, br",
  "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8,ru;q=0.6",
  "rack.version"=>[1, 3],
  "rack.multithread"=>true,
  "REQUEST_PATH"=>"/",
  "rack.tempfiles"=>[]
}
```

---

# Rack Middleware

Each middleware is responsible of calling the next.

lib/custom_header.rb <!-- .element: class="filename" -->
```ruby
module Rack
  class CustomHeader
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      headers['X-Custom-Header'] = 'content'

      [status, headers, body]
    end
  end
end
```

--

lib/welcome.rb <!-- .element: class="filename" -->
```ruby
module Rack
  class Welcome
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env).path

      if req == '/welcome'
        [200, { 'Content-Type' => 'text/plain' }, ['Welcome!']]
      else
        @app.call(env)
      end
    end
  end
end
```

--

config.ru <!-- .element: class="filename" -->

```ruby
require './lib/custom_header'
require './lib/welcome'

app = Rack::Builder.new do
  use Rack::Welcome
  use Rack::CustomHeader
  run proc { |env| [200, { 'Content-Type' => 'text/plain' }, ['Hello!']] }
end

run app
```

```bash
$ rackup
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
  
  private
  
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
  
  private
  
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

use Rack::Static, urls: ['/stylesheets'], root: 'public'
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

---

## Rack::Reloader

When you change some code in your application or in `config.ru` you need to 'rackup' your application one more time.
The reason is that `Rack` is not able to reload the code of application.

For such reason, it's recommended to use `Rack::Reloader` middleware

--

### Using Reloader in middlewares

config.ru <!-- .element: class="filename" -->
```ruby

require_relative './lib/racker'

use Rack::Reloader
use Rack::Static, :urls => ['/assets'], :root => 'public'
run Racker

```


---

## Rack::Sessions

If your application needs to work with sessions or with cookies you could add `Rack::Sessions::Cookie` middleware to your `config.ru` file.

You must add it between `Rack::Reloader` and running the application

--

### Using Rack Sessions

config.ru <!-- .element: class="filename" -->
```ruby
use Rack::Reloader
use Rack::Static, :urls => ['/assets'], :root => 'public'
use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'foo.com',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => 'change_me',
                           :old_secret => 'also_change_me'
run Racker
```

--

### Using Rack Sessions

lib/racker.rb <!-- .element: class="filename" -->
```ruby
class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
      when '/'
        return Rack::Response.new("My name is #{@request.session[:name]}", 200) if session_present?
        Rack::Response.new { |response| response.redirect("/endpoint_where_session_starts") }
      when '/endpoint_where_session_starts'
        Rack::Response.new do |response|
          @request.session[:name] = 'John Doe' unless session_present?
          response.redirect('/')
        end
      else Rack::Response.new('Not Found', 404)
    end
  end

  private

  def session_present?
    @request.session.key?(:name)
  end
end
```

---

## Into Rails

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
use ActionDispatch::Executor
use ActiveSupport::Cache::Strategy::LocalCache::Middleware
use Rack::Runtime
use Rack::MethodOverride
use ActionDispatch::RequestId
use Rails::Rack::Logger
use ActionDispatch::ShowExceptions
use WebConsole::Middleware
use ActionDispatch::DebugExceptions
use ActionDispatch::RemoteIp
use ActionDispatch::Reloader
use ActionDispatch::Callbacks
use ActiveRecord::Migration::CheckPending
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore
use ActionDispatch::Flash
use Rack::Head
use Rack::ConditionalGet
use Rack::ETag
run TestRailsRack::Application.routes
```

Rails on Rack guides - http://guides.rubyonrails.org/rails_on_rack.html

---

<<<<<<< Updated upstream
=======
## Rack Specs

--
### Adding helper gem for testing

```bash
$ bundle add rack-test
```

spec_helper.rb <!-- .element: class="filename" -->
```ruby
  require "rack/test"
  ...

  include Rack::Test::Methods
  ...
```

--

### Test your requests with `rack-test` helpers

```ruby
RSpec.describe Racker do
  def app
    Rack::Builder.parse_file('config.ru').first
  end

  context 'with rack env' do
    let(:user_name) { 'John Doe' }
    let(:env) { { 'HTTP_COOKIE' => "user_name=#{user_name}" } }

    it 'returns ok status' do
      get '/', {}, env
      expect(last_response.body).to include(user_name)
    end
  end

  context 'statuses' do
    it 'returns status not found' do
      get '/unknown'
      expect(last_response).to be_not_found
    end

    it 'returns status ok' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  context 'cookies' do
    it 'sets cookies' do
      set_cookie('user_id=123')
      get '/'
      expect(last_request.cookies).to eq({"user_id"=>"123"})
    end
  end

  context 'redirects' do
    it 'redirects' do
      post '/some_url'
      expect(last_response).to be_redirect
      expect(last_response.header["Location"]).to eq('/redirect_url')
    end
  end
end

```

---

## Codebreaker Web

It's time to move you `Codebreaker` to web interface!  

[Here](https://docs.google.com/document/d/1Q2u3CAmRs1Gg7zO2rT5IlTP_LdBicfBa7OzC6ZjYwZI/edit) are all the details of the task.

---

>>>>>>> Stashed changes
# The End
