---
layout: slide
title:  Rails
---

# The structure of Rails project

![](/assets/images/rails-structure/structure.png)

---

# Prerequisites

--

## Install and setup Git

`Git` - is a version control system for tracking changes in computer files and coordinating work on those files among multiple people.

[Getting Started Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

[First Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)

--

## Clone the repository

```bash
$ git clone https://github.com/WoLkErSs/training_store
```
--

## Setup Postgres database

`PostgreSQL` - is a powerful, open source object-relational database system that uses and extends the SQL language combined with many features that safely store and scale the most complicated data workloads.

[Setup Postgres for Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04)

[Setup Postgres for Mac](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb)

--

## Setup RVM

`RVM` - is a command-line tool which allows you to easily install, manage, and work with multiple ruby environments from interpreters to sets of gems.

[Install RVM for Ubuntu](https://rvm.io/rvm/install)

[Install RVM for Mac](https://null-byte.wonderhowto.com/how-to/mac-for-hackers-install-rvm-maintain-ruby-environments-macos-0174401/)

--

## Setup Ruby 2.6.5 via RVM

Install a version of Ruby (eg 2.6.5)

```bash
$ rvm install 2.6.5
```

Make Ruby 2.6.5 default

```bash
$ rvm --default use 2.6.5
```

Show list of all installed Ruby version on your machine

```bash
$ rvm list
```

Check this worked correctly

```bash
$ ruby -v
```

--

## Install Bundler

Bundler is a popular tool for managing application gem dependencies.

```bash
$ gem install bundler
```

--

## Setup NVM

`NVM` - is a simple bash script to manage multiple active node.js versions.

[Install NVM](https://github.com/nvm-sh/nvm)

--

## Setup Node v10

Install a version of Node (eg v10)

```bash
$ nvm install v10
```
Use installed Node

```bash
$ nvm use v10
```
Show list of all installed Node version on your machine

```bash
$ nvm list
```

[How to Install and Manage Node.js via NVM](https://tecadmin.net/install-nodejs-with-nvm/)

--

## Install Yarn

`Yarn` - is a JavaScript package manager.

[Install Yarn for Ubuntu](https://yarnpkg.com/lang/en/docs/install/#debian-stable)

[Install Yarn for Mac](https://yarnpkg.com/lang/en/docs/install/#mac-stable)

---

## What is Rails?

`Rails` - is a web-application framework that includes everything needed to create database-backed web applications according to the Model-View-Controller [MVC pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).

![](/assets/images/rails-structure/Ruby_On_Rails_Logo.png)

--

## This is a Rails project

```
|-- app
|   |-- assets
|   |-- controllers
|   |-- helpers
|   |-- mailers
|   |-- models
|   `-- views
|-- bin
|   |-- bundle
|   |-- rails
|   |-- rake
|   |-- setup
|   `-- spring
|-- config
|-- db
|-- lib
|-- log
|-- public
|-- spec
|-- tmp
|-- vendor
|- config.ru
|- Gemfile
|- Gemfile.lock
|- package.json
|- Rakefile
|- README.rdoc
|- yarn.lock
```

---

#  What should I do to run application?

--

```bash
$ bundle install
```

`bundle install` - is a command that run Bundler, what will fetch all remote sources, resolve dependencies and install all needed gems.

--

```bash
$ rails db:create
```

`rails db:create` - will create an empty database for the current environment.

```bash
$ rails db:migrate
```

`rails db:migrate` - runs migrations for the current environment and create db/schema.rb file.

```bash
$ rails db:seed
```

`rails db:seed` - runs the db/seed.rb file and seeding your database (`optional`)

--

```bash
$ yarn install
```

`yarn install` - install all the dependencies listed within package.json in the local node_modules folder.

`Note`: Use `yarn install` if production has assets, otherwise it makes no sense.

--

```bash
$ rails s
```

The `rails server` or `rails s` command launches a puma web server. You’ll use this any time you want to access your application through a web browser.

By default Rails server listening on port 3000. Go to your browser and open http://localhost:3000, you will see a Rails app running.

--

## Useful for testing

```bash
$ rails c
```

The `rails console` or `rails c` command lets you interact with your Rails application from the command line. This is useful for testing out quick ideas with code and changing data server-side without touching the website.

---

## Structure of rails folders

|  `Folder`  | `Description` |
|    ---     |  -----------  |
| **app**    | It organizes your application components. It's got subdirectories that hold the views, controllers, models, and more that handle business logic. |
| **bin**    | Contains the rails script that starts your app and can contain other scripts you use to setup, update, deploy or run your application. |
| **config** | Configure your application's routes, database, and more. This is covered in more detail in [Configuring Rails Applications](https://guides.rubyonrails.org/configuring.html). |
| **db**     | Contains your current database schema, as well as the database migrations. |
| **lib**    | Extended modules for your application. |
| **log**    | Application log files. |
| **public** | The only folder seen by the world as-is. Contains static files and compiled assets. |
| **test**   | Unit tests, fixtures, and other test apparatus. |
| **spec**   | Alternative to test directory using BDD. Rspec allows you to write an alternative syntax to Test Unit that reads more like a specification than a test. |
| **tmp**    | Temporary files (like cache and pid files). |
| **vendor** | A place for all third-party code. In a typical Rails application this includes vendored gems. |
|            |               |

--

## app

- `app/assets` - Holds the assets for your application including images, stylesheets, and javascript..

- `app/controllers` − The controllers subdirectory is where Rails looks to find the controller classes. A controller handles a web request from the user.

- `app/channels` - Contains channels used to setup connections with ActionCable.

- `app/helpers` − The helpers subdirectory holds any helper classes used to assist the model, view, and controller classes. This helps to keep the model, view, and controller code small, focused, and uncluttered.

- `app/models` − The models subdirectory holds the classes that model and wrap the data stored in our application's database. In most frameworks, this part of the application can grow pretty messy, tedious, verbose, and error-prone. Rails makes it dead simple!

- `app/view` − The views subdirectory holds the display templates to fill in with data from our application, convert to HTML, and return to the user's browser.

- `app/view/layouts` − Holds the template files for layouts to be used with views. This models the common header/footer method of wrapping views.

--

## config

- `config/application.rb` This contains the main configuration for the application, such as the timezone to use, language, and many other settings.

- `config/boot.rb` As you might imagine, “boots” up the Rails application. `boot.rb` verifies that there is actually a Gemfile present and will store the path to this file in an environment variable called `BUNDLE_GEMFILE` for later use.

- `config/database.yml` This file holds all the database configuration the application needs. Here, different configurations can be set for different environments.

- `config/environment.rb` This file requires application.rb to initialize the Rails application.

- `config/routes.rb`
This is where all the routes of the application are defined. There are different semantics for declaring the routes, examples of which can be found in this file.

- `config/initializers` This directory contains the list of files that need to be run during the Rails initialization process.

- `config/locales` This has the list of YAML file for each language that holds the keys and values to translate bits of the app. You can learn about internationalization (i18n) [here](https://guides.rubyonrails.org/i18n.html).

--

## db

- `db/migrate` Migrations are stored as files in the db/migrate directory, one for each migration class. The name of the file is of the form `YYYYMMDDHHMMSS_create_products.rb`, that is to say a UTC timestamp identifying the migration followed by an underscore followed by the name of the migration.

- `db/schema.rb` It documents the final current state of the database schema. Often, especially when you have more than a couple of migrations, it's hard to deduct the schema just from the migrations alone. With a present schema.rb, you can just have a look there.

- `db/seeds.rb` This file is used to pre fill, or “seed”, database with required records. You can use normal ActiveRecord methods for record insertion.

--

## lib

- `lib/assets` This file holds all the library assets, meaning those items (scripts, stylesheets, images) that are not application specific.

- `lib/tasks` The application’s Rake tasks and other tasks can be put in this directory. Rake tasks mentioned here are required by the app’s `Rakefile`.

--

### `Gemfile`
The Gemfile is the place where all your app’s gem dependencies are declared. This file is mandatory, as it includes the Rails core gems, among other gems.


### `Gemfile.lock`
Gemfile.lock holds the gem dependency tree, including all versions, for the app. This file is generated by bundle install on the above Gemfile. It, in effect, locks your app dependencies to specific versions.

---

# What files and folders I will use often?

--

- **spec**/factories/*
  <br>
  <small>Folder for factories </small>

- **spec**/features/*
  <br>
  <small>Folder for feature tests </small>

- **spec**/support/*
  <br>
  <small>Folder for support files </small>
  
- **spec**/rails_helper.rb
  <br>
  <small>File for configuring rspec-rails </small>

- **spec**/spec_helper.rb
  <br>
  <small>File for configuring rspec </small>

- **config**/routes.rb
  <br>
  <small>File with routes </small>

- **db**/schema.rb
  <br>
  <small>File with db schema </small>

- Gemfile
  <br>
  <small>File with gems </small>

---

# How to work with Gemfile?

--

## Setting up a Gemfile

The first thing we need to do is tell the Gemfile where to look for gems, this is called the source.
We use the #source method for doing this.

Gemfile <!-- .element class="filename" -->

```ruby
source "https://rubygems.org”
```

--

## Selecting a version of Ruby

You can use the `ruby` keyword in your app’s Gemfile to specify a specific version of Ruby.

Gemfile <!-- .element class="filename" -->

```ruby
ruby '2.6.3'
```

--

## Setting up your Gems

Now onto the main point of using a Gemfile, setting up the gems!

The most basic syntax is;

Gemfile <!-- .element class="filename" -->

```ruby
gem 'my_gem'
```

In this case my_gem is the name of the gem. The name is the only thing that is required, there are several optional parameters that you can use.

--

## Setting the version of a Gem

The most common thing you will want to do with a gem is set its version.

If you don’t set a version you are basically saying any version will do;

Gemfile <!-- .element class="filename" -->

```ruby
gem 'my_gem', '>= 0.0.0'
```

There are `seven` operators you can use when specifying your gems.

- `=` Equal To "=1.0"

- `!=` Not Equal To "!=1.0"

- `>` Greater Than ">1.0"

- `<` Less Than "<1.0"

- `>=` Greater Than or Equal To ">=1.0"

- `<=` Less Than or Equal To "<=1.0"

- `~>` Pessimistically Greater Than or Equal To "~>1.0"

--

## Semantic versioning of Gem boils down to:

- `PATCH` 0.0.x level changes for implementation level detail changes, such as small bug fixes

- `MINOR` 0.x.0 level changes for any backwards compatible API changes, such as new functionality/features

- `MAJOR` x.0.0 level changes for backwards incompatible API changes, such as changes that will break existing users code if they update

--

## Grouping your Gem

There are two ways you group a gem. The first is by assigning a value to the :group property;

Gemfile <!-- .element class="filename" -->

```ruby
gem 'my_gem', group: :development
```

The second way you can decide a grouping for a gem is by setting your gems up inside a block;

Gemfile <!-- .element class="filename" -->

```ruby
group :development do
  gem 'my_gem'
  gem 'my_other_gem'
end
```

This is visually more pleasing, and you can combine groups;

Gemfile <!-- .element class="filename" -->

```ruby
group :development, :test do
  gem 'my_gem'
  gem 'my_other_gem'
end
```

--

## Setting a source for your Gem

You can set sources for your gems

Gemfile <!-- .element class="filename" -->

```ruby
gem 'my_gem', source: "https://your_resource.com"
```

Also you can Installing a Gem from Git

Gemfile <!-- .element class="filename" -->

```ruby
gem 'my_gem', git: 'ssh@githib.com/your_resource/my_gem'
```

You can specify that your gem lives locally on your system by passing in the :path parameter.

Gemfile <!-- .element class="filename" -->

```ruby
gem 'my_gem', path: '../my_path/my_gem'
```
---

# Package manager for the JavaScript

--

## What is `NPM`?

`npm` (originally short for Node Package Manager) is a package manager for the JavaScript programming language. It is the default package manager for the JavaScript runtime environment Node.js. It consists of a command line client, also called npm, and an online database of public and paid-for private packages, called the npm registry.

--

## What is `Yarn`?
`Yarn` is a JavaScript package manager for your code, that is a faster alternative to NPM.

The are a few benefits of using Yarn with your Rails application:

- It allows you to use and share code with other developers from around the world.

- You don't have to download packages twice ever again, as Yarn catches every package it downloads.

- It facilitates much faster installation times by stopping other operations to maximize resource - utilization.

- It's secure! Yarn verifies and checks to make sure the installed packages are not compromised before the code is executed.

- Yarn promotes consistency as it ensures one install that works on one system will work on another in the same way.

--

### package.json
`package.json` file with some dependencies that provides information to Yarn about your package.


### package-lock.json
`package-lock.json` is automatically generated for any operations where npm modifies either the node_modules tree, or package.json. It describes the exact tree that was generated, such that subsequent installs are able to generate identical trees, regardless of intermediate dependency updates.

--

## `NPM` vs `Yarn`

Yarn has a few differences from npm. First of all, Yarn caches all installed packages. Yarn is installing the packages simultaneously, and that is why Yarn is faster than NPM. They both download packages from npm repository. Yarn generates yarn.lock to lock down the versions of package’s dependencies by default. On the contrary, npm for this purpose offers `shrinkwrap` CLI command.

### Problems with Yarn

- Problems with installing native modules

- Yarn doesn’t work with any node.js version older than 5

---

# What is `rake tasks`?

--

Rails **rake tasks** are commands that automate specific actions to be used either by the developers or by other mechanisms.

Many tasks come configured with Rails out of the box to provide important functionality.

--

## Using Existing Rake Tasks

**Remember** you must running rake task in Rails project folder.

```bash
$ rake -T         # Lists all rake tasks for the application

$ rake            # Automatically checks for a task named default, and runs that task if one is found

$ rake my_task    # To run a named task "my_task"

$ rake mydoc.pdf  # To run a Rake file or directory task

$ rake —help      # List of all of the available options
```

---

# What is `REST`ful?
### How work with REST in Rails?

--

**REST** stands for **RE**presentational **S**tate **T**ransfer and describes resources (in our case URLs) on which we can perform actions. 

**REST**ful design helps you to create default routes by using resources keyword followed by the controller name in the the `routes.rb` file.

--

## routes

The routes for your application live in the file `config/routes.rb`, and looks like this:

config/routes.rb <!-- .element: class="filename" -->

```ruby
Rails.application.routes.draw do
  resources :user do                           # creates seven routes all mapping to the user controller
    resources :friends, only: %i[destroy]      # creates one nested route mapping to the friends controller
  end
 
  resource :projects, only: %i[create destroy] # creates two routes all mapping to the projects controller
 
  root to: 'home#index'                        # crete one route mapping to the home controller, index action
end
```

--

## How to see List of All Routes?

To list all the routes available for a Rails application you can run this command from within the Ad.

```bash
$ rake routes
```

`rake routes` shows all the routes in the application.

```
Prefix        Verb     URI Pattern                           Controller#Action

user_friend   DELETE   /user/:user_id/friends/:id(.:format)  friends#destroy
 user_index   GET      /user(.:format)                       user#index
              POST     /user(.:format)                       user#create
   new_user   GET      /user/new(.:format)                   user#new
  edit_user   GET      /user/:id/edit(.:format)              user#edit
       user   GET      /user/:id(.:format)                   user#show
              PATCH    /user/:id(.:format)                   user#update
              PUT      /user/:id(.:format)                   user#update
              DELETE   /user/:id(.:format)                   user#destroy
   projects   DELETE   /projects(.:format)                   projects#destroy
              POST     /projects(.:format)                   projects#create
       root   GET      /                                     home#index
```

--

## How To Search Rails Routes?

So let’s say you only want to know which routes have a “/user” in them.

```bash
$ rake routes | grep user
```

```
user_friend   DELETE   /user/:user_id/friends/:id(.:format)  friends#destroy
 user_index   GET      /user(.:format)                       user#index
              POST     /user(.:format)                       user#create
   new_user   GET      /user/new(.:format)                   user#new
  edit_user   GET      /user/:id/edit(.:format)              user#edit
       user   GET      /user/:id(.:format)                   user#show
              PATCH    /user/:id(.:format)                   user#update
              PUT      /user/:id(.:format)                   user#update
              DELETE   /user/:id(.:format)                   user#destroy
```

---

# Credentials

--

### From Rails 5.2 we have new way of handling encrypted credentials

The first thing to notice is that Rails projects come with two files:

- `config/credentials.yml.enc` - encrypted yaml storage (your secret values are stored here)

- `config/master.key` - encryption key

Basically, `credentials.yml.enc` is encrypted with the secret key that's stored in `master.key`. This key named `RAILS_MASTER_KEY`.

--

## How Use, Editing Credentials?

```bash
$ rails credentials:edit
```

This will open up a vim editor with the decrypted version of the file. When you save it, it will encrypt it again using your master key.

config/credentials.yml.enc <!-- .element: class="filename" -->

```ruby
aws:
  access_key_id: 123
  secret_access_key: 345
secret_key_base: 2fdea1259c6660852864f9726616df64c8cd
```

Then, you should be able to access the configuration programmatically like this:

```ruby
Rails.application.credentials.aws[:access_key_id]     # => "123"
Rails.application.credentials.aws[:secret_access_key] # => "345"
Rails.application.credentials.secret_key_base         # => "2fdea...
```
---

# Environment Variables

Ruby has this ENV object that behaves like a hash & it gives you access to all the environment variables that are available to you.


```bash
$ ENV.size          # Show how many keys you have

$ ENV.keys          # List of all keys

$ ENV["RAILS_ENV"]  # Access to specific key
```

---

# The end!
