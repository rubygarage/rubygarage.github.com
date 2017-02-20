---
layout: slide
title:  Devise
---

# Devise

<br>

[Go to Table of Contents](/)

---

## Devise

Devise is a flexible authentication solution for Rails based on Warden. It:

* Is Rack based.
* Is a complete MVC solution based on Rails engines.
* Allows you to have multiple models signed in at the same time.
* Is based on a modularity concept: use only what you really need.

[https://github.com/plataformatec/devise](https://github.com/plataformatec/devise)

---

### Install Devise

Gemfile <!-- .element: class="filename" -->

```ruby
gem 'devise'
```

```bash
$ bundle
$ rails generate devise:install
  create  config/initializers/devise.rb
  create  config/locales/devise.en.yml
  ===============================================================================

  Some setup you must do manually if you haven't yet:

    1. Ensure you have defined default url options in your environments files. Here
       is an example of default_url_options appropriate for a development environment
       in config/environments/development.rb:

         config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

       In production, :host should be set to the actual host of your application.

    2. Ensure you have defined root_url to *something* in your config/routes.rb.
       For example:

         root to: "home#index"

    3. Ensure you have flash messages in app/views/layouts/application.html.erb.
       For example:

         <p class="notice"><%= notice %></p>
         <p class="alert"><%= alert %></p>

    4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

         config.assets.initialize_on_precompile = false

       On config/application.rb forcing your application to not access the DB
       or load models when precompiling your assets.

    5. You can copy Devise views (for customization) to your app by running:

         rails g devise:views
```

---

## Generate Devise MODEL

```bash
$ rails generate devise user
invoke  active_record
  create    db/migrate/20141211212008_devise_create_users.rb
  create    app/models/user.rb
  invoke    rspec
  create      spec/models/user_spec.rb
  insert    app/models/user.rb
   route  devise_for :users
```

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
```

--

db/migrate/20141211212008_devise_create_users.rb <!-- .element: class="filename" -->

```ruby
class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
```

--

config/routes.rb

```ruby
Bookstore::Application.routes.draw do
  devise_for :users
end
```

```bash
$ rake db:migrate
==  DeviseCreateUsers: migrating ==============================================
-- create_table(:users)
   -> 0.0112s
-- add_index(:users, :email, {:unique=>true})
   -> 0.0012s
-- add_index(:users, :reset_password_token, {:unique=>true})
   -> 0.0008s
==  DeviseCreateUsers: migrated (0.0141s) =====================================
```

---

## Log In / Sign Up

app/views/layouts/application.html.erb <!-- .element: class="filename" -->

```html
<!DOCTYPE html>
<html>
<head>
  <title>Bookstore</title>
  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>
</head>
<body>
  <div id="user-nav">
    <% if user_signed_in? %>
      Logged in as <strong><%= current_user.email %></strong>.
      <%= link_to 'Edit profile', edit_user_registration_path %> |
      <%= link_to "Logout", destroy_user_session_path, method: :delete %>
    <% else %>
      <%= link_to "Sign up", new_user_registration_path %> |
      <%= link_to "Login", new_user_session_path %>
    <% end %>
  </div>

  <% flash.each do |name, msg| %>
    <%= content_tag :div, msg, id: "flash-#{name}" %>
  <% end %>

  <%= yield %>
</body>
</html>
```

---

## Generate Views

```bash
$ rails generate devise:views
  invoke  Devise::Generators::SharedViewsGenerator
  create    app/views/devise/shared
  create    app/views/devise/shared/_links.html.erb
  invoke  form_for
  create    app/views/devise/confirmations
  create    app/views/devise/confirmations/new.html.erb
  create    app/views/devise/passwords
  create    app/views/devise/passwords/edit.html.erb
  create    app/views/devise/passwords/new.html.erb
  create    app/views/devise/registrations
  create    app/views/devise/registrations/edit.html.erb
  create    app/views/devise/registrations/new.html.erb
  create    app/views/devise/sessions
  create    app/views/devise/sessions/new.html.erb
  create    app/views/devise/unlocks
  create    app/views/devise/unlocks/new.html.erb
  invoke  erb
  create    app/views/devise/mailer
  create    app/views/devise/mailer/confirmation_instructions.html.erb
  create    app/views/devise/mailer/reset_password_instructions.html.erb
  create    app/views/devise/mailer/unlock_instructions.html.erb
```

---

## Facebook Authentication

Gemfile <!-- .element: class="filename" -->

```ruby
gem 'devise'
gem 'omniauth-facebook'
```

```bash
$ bundle
```

config/initializers/devise.rb <!-- .element: class="filename" -->

```bash
Devise.setup do |config|
  # ...
end
```

---

# The End

<br>

[Go to Table of Contents](/)
