---
layout: slide
title:  Rails
---

# Rails
David Heinemeier Hansson (DHH), [37signals](http://37signals.com)
### The Rails philosophy includes two major guiding principles
DRY - "Don't Repeat Yourself" - suggests that writing the same code over and over again is a bad thing.
Convention Over Configuration - means that Rails makes assumptions about what you want to do and how you're going to
do it, rather than requiring you to specify every little thing through endless configuration files.

---

## Instaling Rails
### Preparing environment
```bash
rvm use 2.3.0@blog --create
Using /Users/ty/.rvm/gems/ruby-2.3.0 with gemset blog
```
### Installing Rails
#### The latest stable version
```bash
gem install rails
```
####
```bash
gem install rails -v 5.0.0.beta1.1
```

---

## Creating rails application
```bash
rails new -h
Usage:
rails new APP_PATH [options]
Options:
-r, [--ruby=PATH]                                      # Path to the Ruby binary of your choice
# Default: /Users/ty/.rvm/rubies/ruby-2.3.0/bin/ruby
-m, [--template=TEMPLATE]                              # Path to some application template (can be a filesystem path or URL)
[--skip-gemfile], [--no-skip-gemfile]              # Don't create a Gemfile
-B, [--skip-bundle], [--no-skip-bundle]                # Don't run bundle install
-G, [--skip-git], [--no-skip-git]                      # Skip .gitignore file
[--skip-keeps], [--no-skip-keeps]                  # Skip source control .keep files
-O, [--skip-active-record], [--no-skip-active-record]  # Skip Active Record files
-S, [--skip-sprockets], [--no-skip-sprockets]          # Skip Sprockets files
[--skip-spring], [--no-skip-spring]                # Dont install Spring application preloader
-d, [--database=DATABASE]                              # Preconfigure for selected database (options: mysql/oracle/postgresql/sqlite3/frontbase/ibm_db/sqlserver/jdbcmysql/jdbcsqlite3/jdbcpostgresql/jdbc)
# Default: sqlite3
-j, [--javascript=JAVASCRIPT]                          # Preconfigure for selected JavaScript library
# Default: jquery
-J, [--skip-javascript], [--no-skip-javascript]        # Skip JavaScript files
[--dev], [--no-dev]                                # Setup the application with Gemfile pointing to your Rails checkout
[--edge], [--no-edge]                              # Setup the application with Gemfile pointing to Rails repository
[--skip-turbolinks], [--no-skip-turbolinks]        # Skip turbolinks gem
-T, [--skip-test-unit], [--no-skip-test-unit]          # Skip Test::Unit files
[--rc=RC]                                          # Path to file containing extra configuration options for rails command
[--no-rc], [--no-no-rc]                            # Skip loading of extra configuration options from .railsrc file
Runtime options:
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
Rails options:
-h, [--help], [--no-help]        # Show this help message and quit
-v, [--version], [--no-version]  # Show Rails version number and quit
```
### Rails new
```bash
rails new blog
create
create  README.md
create  Rakefile
create  config.ru
create  .gitignore
create  Gemfile
create  app
create  app/assets/config/manifest.js
create  app/assets/javascripts/application.js
create  app/assets/javascripts/cable.coffee
create  app/assets/stylesheets/application.css
create  app/channels/application_cable/channel.rb
create  app/channels/application_cable/connection.rb
create  app/controllers/application_controller.rb
create  app/helpers/application_helper.rb
create  app/jobs/application_job.rb
create  app/mailers/application_mailer.rb
create  app/models/application_record.rb
create  app/views/layouts/application.html.erb
create  app/views/layouts/mailer.html.erb
create  app/views/layouts/mailer.text.erb
create  app/assets/images/.keep
create  app/assets/javascripts/channels/.keep
create  app/controllers/concerns/.keep
create  app/models/concerns/.keep
create  bin
create  bin/bundle
create  bin/rails
create  bin/rake
create  bin/setup
create  bin/update
create  config
create  config/routes.rb
create  config/application.rb
create  config/environment.rb
create  config/secrets.yml
create  config/environments
create  config/environments/development.rb
create  config/environments/production.rb
create  config/environments/test.rb
create  config/initializers
create  config/initializers/active_record_belongs_to_required_by_default.rb
create  config/initializers/application_controller_renderer.rb
create  config/initializers/assets.rb
create  config/initializers/backtrace_silencers.rb
create  config/initializers/callback_terminator.rb
create  config/initializers/cookies_serializer.rb
create  config/initializers/cors.rb
create  config/initializers/filter_parameter_logging.rb
create  config/initializers/inflections.rb
create  config/initializers/mime_types.rb
create  config/initializers/request_forgery_protection.rb
create  config/initializers/session_store.rb
create  config/initializers/wrap_parameters.rb
create  config/locales
create  config/locales/en.yml
create  config/redis
create  config/redis/cable.yml
create  config/boot.rb
create  config/database.yml
create  db
create  db/seeds.rb
create  lib
create  lib/tasks
create  lib/tasks/.keep
create  lib/assets
create  lib/assets/.keep
create  log
create  log/.keep
create  public
create  public/404.html
create  public/422.html
create  public/500.html
create  public/favicon.ico
create  public/robots.txt
create  test/fixtures
create  test/fixtures/.keep
create  test/fixtures/files
create  test/fixtures/files/.keep
create  test/controllers
create  test/controllers/.keep
create  test/mailers
create  test/mailers/.keep
create  test/models
create  test/models/.keep
create  test/helpers
create  test/helpers/.keep
create  test/integration
create  test/integration/.keep
create  test/test_helper.rb
create  tmp
create  tmp/.keep
create  tmp/cache
create  tmp/cache/assets
create  vendor/assets/javascripts
create  vendor/assets/javascripts/.keep
create  vendor/assets/stylesheets
create  vendor/assets/stylesheets/.keep
run  bundle install
...
run  bundle exec spring binstub --all
* bin/rake: spring inserted
* bin/rails: spring inserted
```
### Goto directory
```bash
cd blog
```
### Add .ruby-version and .ruby-gemset
.ruby-version
```ruby
2.3.0
```
.ruby-gemset
```ruby
blog
```

---

## Directories structure
| File/Folder | Purpose |
|

---

| app/ | Contains the controllers, models, views, helpers, mailers and assets for your application. You'll focus on this folder for the remainder of this guide. |
| bin/ | Contains the rails script that starts your app and can contain other scripts you use to deploy or run your application. |
| config/ | Configure your application's runtime rules, routes, database, and more. This is covered in more detail in [Configuring Rails Applications](configuring.html) |
| config.ru | Rack configuration for Rack based servers used to start the application. |
| db/ | Contains your current database schema, as well as the database migrations. |
| Gemfile
Gemfile.lock | These files allow you to specify what gem dependencies are needed for your Rails application. These files are used by the Bundler gem. For more information about Bundler, see [the Bundler website](http://gembundler.com) |
| lib/ | Extended modules for your application. |
| log/ | Application log files. |
| public/ | The only folder seen to the world as-is. Contains the static files and compiled assets. |
| Rakefile | This file locates and loads tasks that can be run from the command line. The task definitions are defined throughout the components of Rails. Rather than changing Rakefile, you should add your own tasks by adding files to the lib/tasks directory of your application. |
| README.rdoc | This is a brief instruction manual for your application. You should edit this file to tell others what your application does, how to set it up, and so on. |
| test/ | Unit tests, fixtures, and other test apparatus. These are covered in [Testing Rails Applications](testing.html) |
| tmp/ | Temporary files (like cache, pid and session files) |
| vendor/ | A place for all third-party code. In a typical Rails application, this includes Ruby Gems and the Rails source code (if you optionally install it into your project). |

---

## Gemfile
```ruby
source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta1.1', '= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Puma as the app server
gem 'puma'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :development, :test do
# Call 'byebug' anywhere in the code to stop execution and get a debugger console
gem 'byebug'
end
group :development do
# Access an IRB console on exception pages or by using console in views
gem 'web-console', '~> 3.0'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
#gem 'rails', git: 'https://github.com/rails/rails.git'
#gem 'rails', git: 'git@github.com:rails/rails.git'
#gem 'rails', git: 'git://github.com/rails/rails.git'
#gem 'rails', github: 'rails'
#gem 'rails', path: 'vendor/rails'
```

---

## Database config
config/database.yml
```ruby
# SQLite version 3.x
#   gem install sqlite3
#
#   Ensure the SQLite 3 gem is defined in your Gemfile
#   gem 'sqlite3'
development:
adapter: sqlite3
database: db/development.sqlite3
pool: 5
timeout: 5000
# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
adapter: sqlite3
database: db/test.sqlite3
pool: 5
timeout: 5000
production:
adapter: sqlite3
database: db/production.sqlite3
pool: 5
timeout: 5000
```
MySQL
```ruby
development:
adapter: mysql2
encoding: utf8
database: community_development
username: root
password:
socket: /tmp/mysql.sock
```
Postgresql
```ruby
development:
adapter: postgresql
encoding: unicode
database: community_development
username: root
password:
```

---

## Creating the Database
```bash
rake db:create
```
## Starting up the Web Server
```bash
rails server
```
```bash
rails server -e production -p 6789
```
```bash
rails s
=> Booting Puma
=> Rails 5.0.0.beta1.1 application starting in development on http://localhost:3000
=> Run `rails server -h` for more startup options
=> Ctrl-C to shutdown server
I, [2016-04-03T17:44:50.487276 #21178]  INFO -- : Celluloid 0.17.3 is running in BACKPORTED mode. [ http://git.io/vJf3J ]
Puma 2.16.0 starting...
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://localhost:3000
```

---

## Generate scaffold
```bash
rails generate scaffold Post title:string text:text
Running via Spring preloader in process 22691
invoke  active_record
create    db/migrate/20160403144910_create_posts.rb
create    app/models/post.rb
invoke    test_unit
create      test/models/post_test.rb
create      test/fixtures/posts.yml
invoke  resource_route
route    resources :posts
invoke  scaffold_controller
create    app/controllers/posts_controller.rb
invoke    erb
create      app/views/posts
create      app/views/posts/index.html.erb
create      app/views/posts/edit.html.erb
create      app/views/posts/show.html.erb
create      app/views/posts/new.html.erb
create      app/views/posts/_form.html.erb
invoke    test_unit
create      test/controllers/posts_controller_test.rb
invoke    helper
create      app/helpers/posts_helper.rb
invoke      test_unit
invoke    jbuilder
create      app/views/posts/index.json.jbuilder
create      app/views/posts/show.json.jbuilder
invoke  assets
invoke    coffee
create      app/assets/javascripts/posts.coffee
invoke    css
create      app/assets/stylesheets/posts.css
invoke  css
create    app/assets/stylesheets/scaffold.css
```

---

## Migrations
db/migrate/20160403144910_create_posts.rb
```ruby
class CreatePosts
### Run migration
```bash
rake db:migrate
== CreatePosts: migrating
```==============================================
-- create_table(:posts)
-> 0.0020s
== CreatePosts: migrated (0.0021s)
```=====================================
```

---

## DB schema
db/schema.rb
```ruby
ActiveRecord::Schema.define(version: 20160403144910) do
create_table "posts", force: true do |t|
t.string   "title"
t.text     "text"
t.datetime "created_at"
t.datetime "updated_at"
end
end
```

---

## Routes
config/routes.rb
```ruby
Community::Application.routes.draw do
resources :posts
end
```
```bash
rake routes
Prefix  Verb   URI Pattern               Controller#Action
posts   GET    /posts(.:format)          posts#index
POST   /posts(.:format)          posts#create
new_post   GET    /posts/new(.:format)      posts#new
edit_post   GET    /posts/:id/edit(.:format) posts#edit
post   GET    /posts/:id(.:format)      posts#show
PATCH  /posts/:id(.:format)      posts#update
PUT    /posts/:id(.:format)      posts#update
DELETE /posts/:id(.:format)      posts#destroy
```

---

## Models
app/models/post.rb before v5.0.0.beta1
```ruby
class Post
v5.0.0.beta1
```ruby
class Post
```ruby
class ApplicationRecord

---

## Controllers
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Listing posts
GET localhost:3000/posts
| Title | Text |  |  |  |
|

---

| Facebook’s New Colocation And Image Recognition Patents Tease The Future Of Sharing | Facebook’s empire was built on photo tags and sharing, but it’s a grueling process many neglect. Luckily, new Facebook patents give it tech to continuously capture video whenever your camera is open, rank and surface the best images, and auto-tag them with people, places, and businesses. They tease a future where pattern, facial, and audio recognition identify what you’re seeing for easy sharing. | [Show](/posts/1) | [Edit](/posts/1/edit) | [Destroy](/posts/1){: data-confirm="Are you sure?" data-method="delete" rel="nofollow"} |
[New Post](/posts/new)
GET localhost:3000/posts.json
```javascript
[{"title":"Facebook’s New Colocation And Image Recognition Patents Tease The Future Of Sharing ","text":"Facebook’s empire was built on photo tags and sharing, but it’s a grueling process many neglect. Luckily, new Facebook patents give it tech to continuously capture video whenever your camera is open, rank and surface the best images, and auto-tag them with people, places, and businesses. They tease a future where pattern, facial, and audio recognition identify what you’re seeing for easy sharing.","url":"http://localhost:3000/posts/1.json"}]
```
app/controllers/posts_controller.rb
```ruby
class PostsController
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
app/views/posts/index.json.jbuilder
```ruby
json.array!(@posts) do |post|
json.extract! post, :id, :title, :text
json.url post_url(post, format: :json)
end
```

---

## New post
GET localhost:3000/posts/new
Title
Text
[Back](/posts)
app/controllers/posts_controller.rb
```ruby
class PostsController
app/views/posts/index.html.erb
```ruby
New post
```
app/views/posts/_form.html.erb
```ruby
&lt;%= pluralize(@post.errors.count, "error") %&gt; prohibited this post from being saved:
&lt;% @post.errors.full_messages.each do |msg| %&gt;
&lt;%= msg %&gt;
&lt;% end %&gt;
&lt;%= f.label :title %&gt;
&lt;%= f.text_field :title %&gt;
&lt;%= f.label :text %&gt;
&lt;%= f.text_area :text %&gt;
&lt;%= f.submit %&gt;
```

---

## Create post
app/controllers/posts_controller.rb
```ruby
class PostsController

---

## Show post
GET localhost:3000/posts/1
Post was successfully created.
{: #notice}
`Title:` Facebook’s New Colocation And Image Recognition Patents Tease The Future Of Sharing
`Text:` Facebook’s empire was built on photo tags and sharing, but it’s a grueling process many neglect. Luckily, new
Facebook patents give it tech to continuously capture video whenever your camera is open, rank and surface the best
images, and auto-tag them with people, places, and businesses. They tease a future where pattern, facial, and audio
recognition identify what you’re seeing for easy sharing.
[Edit](/posts/1/edit) \| [Back](/posts)
GET localhost:3000/posts/1.json
{"title":"Facebook’s New Colocation And Image Recognition Patents Tease The Future Of Sharing ","text":"Facebook’s
empire was built on photo tags and sharing, but it’s a grueling process many neglect. Luckily, new Facebook patents
give it tech to continuously capture video whenever your camera is open, rank and surface the best images, and auto-tag
them with people, places, and businesses. They tease a future where pattern, facial, and audio recognition identify
what you’re seeing for easy sharing.","created_at":"2013-06-09T17:07:29.179Z","updated_at":"2013-06-09T17:07:29.179Z"}
app/controllers/posts_controller.rb
```ruby
class PostsController
app/views/posts/show.html.erb
```ruby
&lt;%= notice %&gt;
Title:
&lt;%= @post.title %&gt;
Text:
&lt;%= @post.text %&gt;
|
```
app/views/posts/show.json.jbuilder
```ruby
json.extract! @post, :title, :text, :created_at, :updated_at
```

---

## Edit post
GET localhost:3000/posts/1/edit
Title
Text
Facebook’s empire was built on photo tags and sharing, but it’s a grueling process many neglect. Luckily, new Facebook patents give it tech to continuously capture video whenever your camera is open, rank and surface the best images, and auto-tag them with people, places, and businesses. They tease a future where pattern, facial, and audio recognition identify what you’re seeing for easy sharing.
[Show](/posts/1) | [Back](/posts)
app/controllers/posts_controller.rb
```ruby
class PostsController
app/views/posts/edit.html.erb
```ruby
|
```
app/views/posts/_form.html.erb
```ruby
&lt;%= pluralize(@post.errors.count, "error") %&gt; prohibited this post from being saved:
&lt;% @post.errors.full_messages.each do |msg| %&gt;
&lt;%= msg %&gt;
&lt;% end %&gt;
&lt;%= f.label :title %&gt;
&lt;%= f.text_field :title %&gt;
&lt;%= f.label :text %&gt;
&lt;%= f.text_area :text %&gt;
&lt;%= f.submit %&gt;
```

---

## Update post
app/controllers/posts_controller.rb
```ruby
class PostsController
```ruby
```

---

## Delete post
app/controllers/posts_controller.rb
```ruby
class PostsController
```ruby
```

---

## Layout
app/views/layouts/application.html.erb
```ruby
Blog
true %>
true %>
```

---

## ApplicationController
app/controllers/application_controller.rb
```ruby
class ApplicationController

---

## Helpers
app/helpers/posts_helper.rb
```ruby
module PostsHelper
def post_short_description(post)
return post.text if post.text.length
app/views/posts/index.html.erb
```ruby
Posts
&lt;%= news_count %&gt;
Title
Text
```

---

## Assets
app/assets/javascripts/application.js
```ruby
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
```
app/assets/stylesheets/application.css
```ruby
/*
*= require_self
*= require_tree .
*/
```
```ruby
Community
...
```
