---
layout: slide
title:  Rails
---

# The structure of Rails project

![](/assets/images/rails-structure/structure.png)

---

# Prerequisites

--

## Instaling and setup Git

`Git` - is a version control system for tracking changes in computer files and coordinating work on those files among multiple people.

[Getting Started Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

[First Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)

--

## Clone the repository

```bash
$ git clone todo_repository_name
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

##  What should i do to run application?

```bash
$ bundle install
```

`bundle install` - is a command that run Bundler, what will fetch all remote sources, resolve dependencies and install all needed gems.

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

`rails db:seed` - runs the db/seed.rb file and seeding your database.

```bash
$ yarn install
```

`yarn install` - install all the dependencies listed within package.json in the local node_modules folder.

---

# What is a structure of rails folders?

---

## `app folder`

This is the core directory of your entire app and most of the application-specific code will go into this directory. As you may know, Rails is an MVC framework, which means the application is separated into parts per its purpose in the Model, View, or Controller. These three sections goes inside this directory.

--

### `app/assets`
This contains the static files required for the application’s front-end grouped into folders based on their type. The javascript files and stylesheets (CSS) in these folders should be application specific since the external library files would go into another directory (vendor) which we will look at in a bit.

--

### `app/assets/images`
All the images required for the application should go into this directory. The images here are available in views through nifty helpers like image_tag("img_name.png") so that you don’t have to specify the relative or absolute path for images.

--

### `app/assets/javascripts`
The javascript files go here. There is a convention to create the JS files for each controller. For example, for books_controller.rb, the JS functions for this controller’s views would be books.js.

--

### `app/assets/stylesheets`
Similar to /javascripts, the CSS files go here. The naming convention is also the same as the javascript assets.

--

### `app/controllers`
This is where all the controller files go. Controllers are responsible for orchestrating the model and views. The naming convention for the file is the pluralized model name + “_controller”. For example, the controller for the Book model is books_controller.rb, which is called “snake case”. Also, the controller class will be CamelCase which is BooksController.

--

### `app/helpers`
This is where all the helper functions for views reside. There are already a few pre-created helpers available, like the one we reference above (image_tag) for referring to images in views. You can create your own functions in a controller specific helper file, which will be automatically created when you use Rails generators to create the controller.

--

### `app/mailers`
The mailers directory contains the mail (as in “email”) specific functions for the application. Mailers are similar to controllers and they will have their view files in app/views/mailer_name/. 

--

### `app/models`
All model files live in the app/models directory. Models act as object-relational mappers to the database tables that hold the data. The naming convention is simply modelname.rb. The model name is, by convention, the singular form of the underlying table that represents the model in the database.

--

### `app/views`
The third part of the MVC architecture are the views. The files related to the views go into this directory. The files are a combination of HTML and Ruby (called Embedded Ruby or Erb) and are organized based on the controller to which they correspond. There is a view file for each controller action.

---

## `bin folder`
This directory contains Binstubs for the Rails application. Binstubs are nothing but wrappers to run the gem executables scoped to your application. This can be used in place of bundle exec `command`. The default available Binstubs are bundle, rails, rake, setup, and spring.

---

## `config folder`
As the name suggests this contains all the application’s configuration files. The database connection and application behavior can be altered by the files inside this directory.

--

### `config/application.rb`
This contains the main configuration for the application, such as the timezone to use, language, and many other settings. The full list could be found here. Also, note the configurations specified here is for all environments (development, test, and production). Environment specific configurations will go into other files, which we’ll see below.

--

### `config/boot.rb`
boot.rb, as you might imagine, “boots” up the Rails application. Rails apps keep gem dependencies in a file called Gemfile in the root of the project. The Gemfile contains all the dependencies required for the application to run. boot.rb verifies that there is actually a Gemfile present and will store the path to this file in an environment variable called BUNDLE_GEMFILE for later use. boot.rb also requires 'bundler/setup' which will fetch and build the gems mentioned in the Gemfile using Bundler.

--

### `config/database.yml`
This file holds all the database configuration the application needs. Here, different configurations can be set for different environments.

--

### `config/environment.rb`
This file requires application.rb to initialize the Rails application.

--

### `config/routes.rb`
This is where all the routes of the application are defined. There are different semantics for declaring the routes, examples of which can be found in this file.

--

### `config/secrets.yml`
Newly added in Rails 4.1, this gives you a place to store application secrets. The secrets defined here are available throughout the application using Rails.application.secrets.`secret_name`.

--

### `config/environments`
As I mentioned above, this folder contains the environment-specific configuration files for the development, test, and production environments. Configurations in application.rb are available in all environments, whereas you can separate out different configurations for the different environments by adding settings to the environment named files inside this directory. Default environment files available are, development.rb, production.rb, test.rb, but you can add others, if needed.

--

### `config/initializers`
This directory contains the list of files that need to be run during the Rails initialization process. Any *.rb file you create here will run during the initialization automatically. For example, constants that you declare in here will then be available throughout your app. The initializer file is triggered from the call in config/environment.rb to Rails.application.initialize!.

--

### `config/locales`
This has the list of YAML file for each language that holds the keys and values to translate bits of the app. You can learn about internationalization (i18n) and the settings from [here](https://guides.rubyonrails.org/i18n.html).

---

## `db folder`
All the database related files go inside this folder. The configuration, schema, and migration files can be found here, along with any seed files.

--

### `db/migrate`
Migrations are stored as files in the db/migrate directory, one for each migration class. The name of the file is of the form YYYYMMDDHHMMSS_create_products.rb, that is to say a UTC timestamp identifying the migration followed by an underscore followed by the name of the migration.

--

### `db/schema.rb`
It documents the final current state of the database schema. Often, especially when you have more than a couple of migrations, it's hard to deduct the schema just from the migrations alone. With a present schema.rb, you can just have a look there.

--

### `db/seeds.rb`
This file is used to pre fill, or “seed”, database with required records. You can use normal ActiveRecord methods for record insertion.

---

## `lib folder`
lib directory is where all the application specific libraries goes. Application specific libraries are re-usable generic code extracted from the application. Think of it as an application specific gem.

--

### `lib/assets`
This file holds all the library assets, meaning those items (scripts, stylesheets, images) that are not application specific.

--

### `lib/tasks`
The application’s Rake tasks and other tasks can be put in this directory. Rake tasks mentioned here are required by the app’s `Rakefile`.

---

## `vendor folder`
This is where the vendor files go, such as javascript libraries and CSS files, among others. Files added here will become part of the asset pipeline automatically.

---

## `public folder`
The public directory contains some of the common files for web applications. By default, HTML templates for HTTP errors, such as 404, 422 and 500, are generated along with a favicon and a robots.txt file. Files that are inside this directory are available in https://appname.com/filename directly.

---

## `rspec folder`
This directory contains all the test files for the app. A subdirectory is created for each component’s test files.

---

## `log folder`
This holds all the log files. Rails automatically creates files for each environment.

---

## What is Gems?

`Gem - is a library` Gem allows you to use ready-made solutions for your application created by other developers and kindly provided for public use.

--

### `Gemfile`
The Gemfile is the place where all your app’s gem dependencies are declared. This file is mandatory, as it includes the Rails core gems, among other gems.

--

### `Gemfile.lock`
Gemfile.lock holds the gem dependency tree, including all versions, for the app. This file is generated by bundle install on the above Gemfile. It, in effect, locks your app dependencies to specific versions.

---

## How to work with Gemfile?

--

### Setting up a Gemfile

The first thing we need to do is tell the Gemfile where to look for gems, this is called the source.
We use the #source method for doing this.
```
source "https://rubygems.org”
```

--

### Setting up your Gems

Now onto the main point of using a Gemfile, setting up the gems!

The most basic syntax is;

```
gem "my_gem"
```

In this case my_gem is the name of the gem. The name is the only thing that is required, there are several optional parameters that you can use.

--

### Setting the version of a Gem

The most common thing you will want to do with a gem is set its version.

If you don’t set a version you are basically saying any version will do;

```
gem "my_gem", ">= 0.0.0"
```
There are `seven` operators you can use when specifying your gems.

- = Equal To "=1.0"
- != Not Equal To "!=1.0"
- \> Greater Than ">1.0"
- < Less Than "<1.0"
- \>= Greater Than or Equal To ">=1.0"
- <= Less Than or Equal To "<=1.0"
- ~> Pessimistically Greater Than or Equal To "~>1.0"

--

### Semantic versioning of Gem boils down to:

- `PATCH` 0.0.x level changes for implementation level detail changes, such as small bug fixes

- `MINOR` 0.x.0 level changes for any backwards compatible API changes, such as new functionality/features

- `MAJOR` x.0.0 level changes for backwards incompatible API changes, such as changes that will break existing users code if they update

--

### Grouping your Gem

There are two ways you group a gem. The first is by assigning a value to the :group property;

```
gem "my_gem", group: :development
```

The second way you can decide a grouping for a gem is by setting your gems up inside a block;

```
  group :development do
    gem "my_gem"
    gem "my_other_gem"
  end
```

This is visually more pleasing, and you can combine groups;

```
group :development, :test do
  gem "my_gem"
  gem "my_other_gem"
end
```

If there is a group you want to be optional you can pass optional: true before the block;

```
group :development, optional: true do
  gem "my_gem"
  gem "my_other_gem"
end
```

--

### Setting a source for your Gem

You can set sources for your gems

```
gem "my_gem", source: "https://your_resource.com"
```

Also you can Installing a Gem from Git

```
gem "my_gem", git: "ssh@githib.com/your_resource/my_gem”
```

You can specify that your gem lives locally on your system by passing in the :path parameter.

```
gem "my_gem", :path => "../my_path/my_gem”
```
---

### What is `Yarn`?
`Yarn` is a JavaScript package manager for your code, that is a faster alternative to NPM.

The are a few benefits of using Yarn with your Rails application:

- It allows you to use and share code with other developers from around the world.
- You don't have to download packages twice ever again, as Yarn catches every package it downloads.
- It facilitates much faster installation times by stopping other operations to maximize resource - utilization.
- It's secure! Yarn verifies and checks to make sure the installed packages are not compromised before the code is executed.
- Yarn promotes consistency as it ensures one install that works on one system will work on another in the same way.

--

### package.json
A `package.json` file with some dependencies that provides information to Yarn about your package.


### package-lock.json
`package-lock.json` is automatically generated for any operations where npm modifies either the node_modules tree, or package.json. It describes the exact tree that was generated, such that subsequent installs are able to generate identical trees, regardless of intermediate dependency updates.

---

## The end!