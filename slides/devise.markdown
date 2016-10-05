---
layout: slide
title:  Devise
---

# Devise
Devise is a flexible authentication solution for Rails based on Warden. It:
* Is Rack based.
* Is a complete MVC solution based on Rails engines.
* Allows you to have multiple models signed in at the same time.
* Is based on a modularity concept: use only what you really need.
[https://github.com/plataformatec/devise][1]

---

## Install Devise
Gemfile
```ruby
gem 'devise'
```
```bash
$ bundle
```
```bash
$ rails generate devise:install
create  config/initializers/devise.rb
create  config/locales/devise.en.yml
```=========================================================================
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
&lt;%= notice %&gt;
&lt;%= alert %&gt;
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
app/models/user.rb
```ruby
class User
db/migrate/20141211212008_devise_create_users.rb
```ruby
class DeviseCreateUsers
config/routes.rb
```ruby
Bookstore::Application.routes.draw do
devise_for :users
end
```
```bash
$ rake db:migrate
==  DeviseCreateUsers: migrating
```========================================
-- create_table(:users)
-> 0.0112s
-- add_index(:users, :email, {:unique=>true})
-> 0.0012s
-- add_index(:users, :reset_password_token, {:unique=>true})
-> 0.0008s
==  DeviseCreateUsers: migrated (0.0141s)
```===============================
```

---

## LogIn/SignUp
app/views/layouts/application.html.erb
```ruby
Bookstore
true %>
true %>
&lt;% if user_signed_in? %&gt;
Logged in as &lt;%= current_user.email %&gt;.
&lt;%= link_to 'Edit profile', edit_user_registration_path %&gt; |
&lt;%= link_to "Logout", destroy_user_session_path, method: :delete %&gt;
&lt;% else %&gt;
&lt;%= link_to "Sign up", new_user_registration_path %&gt; |
&lt;%= link_to "Login", new_user_session_path %&gt;
&lt;% end %&gt;
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
Gemfile
```ruby
gem 'devise'
gem 'omniauth-facebook'
```
```bash
$ bundle
```
config/initializers/devise.rb
```bash
Devise.setup do |config|
# ...
# ...
end
```
[1]: https://github.com/plataformatec/devise
