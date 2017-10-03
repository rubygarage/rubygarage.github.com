---
layout: slide
title:  Rails Engine
---

# RailsEngines

---

## RailsEngines

Rails Engines is basically a whole Rails app that lives in the container of another one. A Rails application is
actually just a "supercharged" engine, with the Rails::Application class inheriting a lot of its behavior from
Rails::Engine.

[Rails Engine documentation](http://guides.rubyonrails.org/engines.html)

---

## Generating an engine

```bash
$ rails plugin new shopping_cart --dummy-path=spec/dummy --skip-test-unit --mountable
    create
    create  README.md
    create  Rakefile
    create  shopping_cart.gemspec
    create  MIT-LICENSE
    create  .gitignore
    create  Gemfile
    create  app
    create  app/controllers/shopping_cart/application_controller.rb
    create  app/helpers/shopping_cart/application_helper.rb
    create  app/jobs/shopping_cart/application_job.rb
    create  app/mailers/shopping_cart/application_mailer.rb
    create  app/models/shopping_cart/application_record.rb
    create  app/views/layouts/shopping_cart/application.html.erb
    create  app/assets/images/shopping_cart
    create  app/assets/images/shopping_cart/.keep
    create  config/routes.rb
    create  lib/shopping_cart.rb
    create  lib/tasks/shopping_cart_tasks.rake
    create  lib/shopping_cart/version.rb
    create  lib/shopping_cart/engine.rb
    create  app/assets/config/shopping_cart_manifest.js
    create  app/assets/stylesheets/shopping_cart/application.css
    create  app/assets/javascripts/shopping_cart/application.js
    create  bin/rails
    create  test/test_helper.rb
    create  test/shopping_cart_test.rb
    append  Rakefile
    create  test/integration/navigation_test.rb
vendor_app  spec/dummy
       run  bundle install
```

---

## Files structure

shopping_cart.gemspec <!-- .element: class="filename" -->

```ruby
$:.push File.expand_path("../lib", __FILE__)
 
# Maintain your gem's version:
require "shopping_cart/version"
 
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shopping_cart"
  s.version     = ShoppingCart::VERSION
  s.authors     = ["Vladimir Vorobyov"]
  s.email       = ["sparrowpublic@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ShoppingCart."
  s.description = "TODO: Description of ShoppingCart."
  s.license     = "MIT"
 
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
 
  s.add_dependency "rails", "~> 5.0.1"
 
  s.add_development_dependency "sqlite3"
end
```

--

lib/shopping_cart.rb <!-- .element: class="filename" -->

```ruby
require "shopping_cart/engine"
 
module ShoppingCart
end
```

lib/shopping_cart/engine.rb <!-- .element: class="filename" -->

```ruby
module ShoppingCart
  class Engine < ::Rails::Engine
    isolate_namespace ShoppingCart
  end
end
```

app/controllers/shopping_cart/application_controller.rb <!-- .element: class="filename" -->

```ruby
module ShoppingCart
  class ApplicationController < ActionController::Base
  end
end
```

config/routes.rb <!-- .element: class="filename" -->

```ruby
ShoppingCart::Engine.routes.draw do
end
```

Then ensure that this file is loaded at the top of your config/application.rb (or in your Gemfile) and it will
automatically load models, controllers and helpers inside app, load routes at config/routes.rb, load locales at
config/locales/\*, and load tasks at lib/tasks/\*.

---

## Testing with RSpec, Capybara, and FactoryGirl

Add these lines to the gemspec file

```ruby
s.add_development_dependency 'rspec-rails'
s.add_development_dependency 'capybara'
s.add_development_dependency 'factory_girl_rails'
```

Add this line to your gemspec file

```ruby
s.test_files = Dir["spec/**/*"]
```

--

Modify `Rakefile` to look like this

```ruby
#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
 
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
 
Bundler::GemHelper.install_tasks
Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
 
require 'rspec/core'
require 'rspec/core/rake_task'
 
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(spec: 'app:db:test:prepare')
 
task default: :spec
```

--

Create a `spec/spec_helper.rb` file

```ruby
ENV['RAILS_ENV'] ||= 'test'
 
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
 
Rails.backtrace_cleaner.remove_silencers!
 
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
 
RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end
```

Add this config to your engine file

```ruby
module ShoppingCart
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework      :rspec,        fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
```

---

## Configuration

`Rails::Engine` allows you to wrap a specific Rails application or subset of functionality and share it with other
applications or within a larger packaged application. Since Rails 3.0, every `Rails::Application` is just an engine,
which allows for simple feature and application sharing.

Any `Rails::Engine` is also a `Rails::Railtie`, so the same methods (like rake_tasks and generators) and configuration
options that are available in railties can also be used in engines.

Besides the [Railtie](https://github.com/rails/rails/blob/master/railties/lib/rails/railtie.rb) configuration which
is shared across the application, in a `Rails::Engine` you can access autoload_paths, eager_load_paths and
autoload_once_paths, which, differently from a Railtie, are scoped to the current engine.

lib/shopping_cart/engine.rb <!-- .element: class="filename" -->

```ruby
class MyEngine < Rails::Engine
  # Add a load path for this specific Engine
  config.autoload_paths << File.expand_path("../lib/some/path", __FILE__)
 
  config.generators do |g|
    g.orm             :active_record
    g.template_engine :erb
    g.test_framework  :test_unit
  end
 
  # To add an initialization step from your Railtie to Rails boot process, you just need to create an initializer block
  initializer "my_engine.add_middleware" do |app|
    # some code
  end
end
```

---

## Rack and Middleware stack

### Endpoint

An engine can also be a rack application. It can be useful if you have a rack application that you would like to wrap
with Engine and provide with some of the Engine's features.

```ruby
module MyEngine
  class Engine < Rails::Engine
    endpoint MyRackApplication
  end
end
```

Now you can mount your engine in application's routes

```ruby
Rails.application.routes.draw do
  mount MyEngine::Engine => '/engine'
end
```

### Middleware stack

As an engine can now be a rack endpoint, it can also have a middleware stack.

```ruby
module MyEngine
  class Engine < Rails::Engine
    middleware.use SomeMiddleware
  end
end
```

---

## Full or mountable

Both options will generate an engine. The difference is that `--mountable` will create the engine in an isolated
namespace, whereas `--full` will create an engine that shares the namespace of the main app.

The differences will be manifested in 3 ways.

--

### The engine class file will call isolate_namespace

#### Full engine

lib/my_full_engine/engine.rb <!-- .element: class="filename" -->

```ruby
module MyFullEngine
  class Engine < Rails::Engine
  end
end
```

#### Mounted engine

lib/my_mountable_engine/engine.rb <!-- .element: class="filename" -->

```ruby
module MyMountableEngine
  class Engine < Rails::Engine
    isolate_namespace MyMountableEngine # --mountable option inserted this line
  end
end
```

--

### The engine's config/routes.rb file will be namespaced

#### Full engine

```ruby
Rails.application.routes.draw do
end
```

#### Mounted engine

```ruby
MyMountableEngine::Engine.routes.draw do
end
```

The parent application could bundle it's functionality under a single route such as

```ruby
mount MyMountableEngine::Engine => '/engine', :as => 'namespaced'
```

--

### The file structure for controllers, helpers, views, and assets will be namespaced

```text
create app/controllers/my_mountable_engine/application_controller.rb
create app/helpers/my_mountable_engine/application_helper.rb
create app/mailers
create app/models
create app/views/layouts/my_mountable_engine/application.html.erb
create app/assets/images/my_mountable_engine
create app/assets/stylesheets/my_mountable_engine/application.css
create app/assets/javascripts/my_mountable_engine/application.js
create config/routes.rb
create lib/my_mountable_engine.rb
create lib/tasks/my_mountable_engine.rake
create lib/my_mountable_engine/version.rb
create lib/my_mountable_engine/engine.rb
```

---

## Isolated Engine

```ruby
module MyEngine
  class Engine < Rails::Engine
    isolate_namespace MyEngine
  end
end
```

```ruby
module MyEngine
  class FooController < ActionController::Base
  end
end
```

--

### Routes

config/routes.rb <!-- .element: class="filename" -->

```ruby
Rails.application.routes.draw do
  mount MyEngine::Engine => '/my_engine', as: 'my_engine'
  get '/foo' => 'foo#index'
end
```

You can use the my_engine helper inside your application

```ruby
class FooController < ApplicationController
  def index
    my_engine.root_url # => /my_engine/
  end
end
```

There is also a main_app helper that gives you access to application's routes inside Engine

```ruby
module MyEngine
  class BarController
    def index
      main_app.foo_path # => /foo
    end
  end
end
```

--

### Helpers

For few specific helpers

```ruby
class ApplicationController < ActionController::Base
  helper MyEngine::SharedEngineHelper
end
```

For all of the engine's helpers

```ruby
class ApplicationController < ActionController::Base
  helper MyEngine::Engine.helpers
end
```

--

### Migrations & seed data

To use engine's migrations

```bash
$ rake ENGINE_NAME:install:migrations
```

To use engine's seed

```ruby
MyEngine::Engine.load_seed
```

---

# The End
