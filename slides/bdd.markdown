---
layout: slide
title:  BDD
---

# Behavior-driven development

`BDD` is about implementing an application by describing its behaviour from the perspective of its stakeholders.

<!-- .element: style="display: block; text-align: left" -->

> * User stories
> * Domain-Driven Development
> * Extreme Programming
>   * Test-Driven Development
>   * Acceptance Driven Test Planning
>   * Continuous Integration

<!-- .element: style="display: block" -->

---

# BDD cycle

--

![](/rubygarage/assets/images/bdd/bdd-cycle-around-tdd-cycles.png)

1. Start with an Acceptance Test scenatio.
2. Run the Acceptance Test scenatio.
3. Red/Green/Refactor wuth Unit Tests.
  * View
  * Controller
  * Model
4. Run the Acceptance Test scenatio again.

---

# Init enviropment

--

## Create gemset

```bash
rvm use 2.3.4@bookstore --create
Using /Users/sparrow/.rvm/gems/ruby-2.3.4 with gemset bookstore
```
<!-- .element: class="command-line" data-output="2" -->

--

## Install Rails

```bash
gem install --no-rdoc --no-ri rails
```
<!-- .element: class="command-line" -->

--

## Create Application

```bash
rails new bookstore --skip-bundle -T
```
<!-- .element: class="command-line" -->

--

## Add gems

Gemfile <!-- .element: class="filename" -->
```ruby
...
group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
end
...
```

```bash
bundle install
```
<!-- .element: class="command-line" -->

---

# Init testing tools

--

## Init RSpec

```bash
rails g rspec:install
create  .rspec
  create  spec
  create  spec/spec_helper.rb
```
<!-- .element: class="command-line" data-output="2-4"-->

config/application.rb <!-- .element: class="filename" -->
```ruby
config.generators do |g|
  g.test_framework :rspec
end
```

--

spec/spec_helper.rb <!-- .element: class="filename" -->
```ruby
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

spec/features/features_spec_helper.rb <!-- .element: class="filename" -->
```ruby
require 'spec_helper'
require 'capybara/rspec'
```

---

# Meet the Capybara

--

![](/rubygarage/assets/images/bdd/capybara.jpg) <!-- .element: style="width: 700px" -->

`Capybara` is acceptance test framework for web applications.

Capybara helps to test web applications by simulating how a real user would interact with an app.

Test your app with [Capybara](http://jnicklas.github.io/capybara/)

---

# Registration feature

specs/features/registration_spec.rb <!-- .element: class="filename" -->

```ruby
feature 'Registration' do
  scenario 'Visitor registers successfully via register form' do
    visit register_path
    within '#new_user' do
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: '12345678'
      click_button('Sign up')
    end
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'You registered'
  end
end
```

```bash
rspec spec/features/registration_spec.rb
NameError:
  undefined local variable or method 'register_path' for #<RSpec::Core::ExampleGroup::Nested_1:0x007fa4b2fb9538>
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Fix `register_path` error

config/routes.rb <!-- .element: class="filename" -->
```ruby
Bookstore::Application.routes.draw do
  get 'register', to: 'users#new', as: 'register'
end
```

```bash
rspec spec/features/registration_spec.rb
ActionController::RoutingError:
  uninitialized constant UsersController
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Fix uninitialized constant UsersController

app/controllers/users_controller.rb <!-- .element: class="filename" -->
```ruby
class UsersController < ApplicationController
end
```

```bash
rspec spec/features/registration_spec.rb
AbstractController::ActionNotFound:
  The action 'new' could not be found for UsersController
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Fix the action 'new' could not be found for UsersController

app/controllers/users_controller.rb <!-- .element: class="filename" -->
```ruby
class UsersController < ApplicationController
  def new
  end
end
```

```bash
rspec spec/features/registration_spec.rb
Missing template users/new, application/new
```
<!-- .element: class="command-line" data-output="2"-->

---

# Fix missing template 'users/new'

`app/views/users/new.html.erb` created

```bash
rspec spec/features/registration_spec.rb
Capybara::ElementNotFound:
  Unable to find css "#new_user"
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# View specs

spec/views/users/new_spec.rb <!-- .element: class="filename" -->
```ruby
describe 'users/new.html.erb' do
  it 'has new_user form' do
    user = mock_model("User").as_new_record
    assign(:user, user)
    render
    expect(rendered).to have_selector('form#new_user')
  end
end
```

--

```bash
rspec spec/views/users/new_spec.rb
Capybara::ExpectationNotMet:
  expected to find css "form#new_user" but there were no matches
```
<!-- .element: class="command-line" data-output="2-3"-->

app/views/users/new.html.erb <!-- .element: class="filename" -->
```html
<%= form_for @user do |f| %>
<%- end %>
```

```bash
rspec spec/views/users/new_spec.rb
ActionView::Template::Error:
   undefined method 'users_path' for #<#<Class:0x007f91f5982a68>:0x007f91f5a36e78>
```
<!-- .element: class="command-line" data-output="2-3"-->

config/routes.rb <!-- .element: class="filename" -->
```ruby
Bookstore::Application.routes.draw do
  get 'register', to: 'users#new', as: 'register'
  resources :users
end
```

```bash
rspec spec/views/users/new_spec.rb
1 example, 0 failures
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# More view specs

spec/views/users/new_spec.rb <!-- .element: class="filename" -->

```ruby
describe 'users/new.html.erb' do
  let(:user) { mock_model("User").as_new_record }

  before do
    user.stub(:email).stub(:password)
    assign(:user, user)
    render
  end

  it 'has new_user form' do
    expect(rendered).to have_selector('form#new_user')
  end

  it 'has user_email field' do
    expect(rendered).to have_selector('#user_email')
  end

  it 'has user_password field' do
    expect(rendered).to have_selector('#user_password')
  end

  it 'has register button' do
    expect(rendered).to have_selector('input[type="submit"]')
  end
end
```

--

app/views/users/new.html.erb <!-- .element: class="filename" -->
```html
<%= form_for @user do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.submit "Sign up" %>
<%- end %>
```

Run views

```bash
rspec spec/views/users/new_spec.rb
4 examples, 0 failures
```
<!-- .element: class="command-line" data-output="2"-->

Run features

```bash
rspec spec/features/registration_spec.rb
ActionView::Template::Error:
  First argument in form cannot contain nil or be empty
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Controller specs

spec/controllers/users_controller_spec.rb <!-- .element: class="filename" -->
```ruby
describe UsersController do
  describe 'GET new' do
    let(:user) { mock_model("User").as_new_record }

    before do
      User.stub(:new).and_return(user)
      get :new
    end

    it 'assigns @user variable' do
      expect(assigns[:user]).to eq(user)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end
end
```

--

app/controllers/users_controller.rb <!-- .element: class="filename" -->
```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end
end
```

```bash
rspec spec/controllers/users_controller_spec.rb
NameError:
  uninitialized constant User
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Model specs

spec/models/user_spec.rb <!-- .element: class="filename" -->
```ruby
describe User do
  let(:user) { User.new }

  it { expect(user).to validate_presence_of(:email) }
  it { expect(user).to validate_uniqueness_of(:email) }
  it { expect(user).to validate_presence_of(:password) }
end
```

```bash
rails g model User email:string password:string
invoke  active_record
create    db/migrate/20140121123310_create_users.rb
create    app/models/user.rb
invoke    rspec
conflict  spec/models/user_spec.rb
skip      spec/models/user_spec.rb

rake db:migrage
```
<!-- .element: class="command-line" data-output="2-8"-->

--

app/models/user.rb <!-- .element: class="filename" -->
```ruby
class User < ActiveRecord::Base
  validates :email, :password, presence: true
  validates :email, uniqueness: true
end
```

```bash
rspec spec/models/user_spec.rb
3 examples, 0 failures

rspec spec/controllers/users_controller_spec.rb
2 examples, 0 failures

rspec spec/features/registration_spec.rb
AbstractController::ActionNotFound:
  The action 'create' could not be found for UsersController
```
<!-- .element: class="command-line" data-output="2-3,5-6,8-9"-->

---

# Fix the action 'create' could not be found error

--

spec/controllers/users_controller_spec.rb <!-- .element: class="filename" -->
```ruby
describe UsersController do

  # ...

  describe 'POST create' do
    let(:user) { mock_model(User, params) }
    let(:params) { {email: Faker::Internet.email, password: '12345678'} }

    before do
      User.stub(:new).and_return(user)
    end

    it 'sends save message to user model' do
      user.should_receive(:save)
      post :create, user: params
    end

    context 'when save message returns true' do
      before do
        user.stub(:save).and_return(true)
        post :create, user: params
      end

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end

      it 'assings a success flash message' do
        expect(flash[:notice]).not_to be_nil
      end

      it 'logs in user' do
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end
end
```

--

app/controllers/users_controller.rb <!-- .element: class="filename" -->
```ruby
class UsersController < ApplicationController

  # ...

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "You registered"
    else
      flash.now[:error] = "Something went wrong"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
```

```bash
rspec spec/controllers/users_controller_spec.rb
NameError:
  undefined local variable or method 'root_url' for #<UsersController:0x007fbacc9f1918>
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Fix undefined local variable or method 'root_url' error

config/routes.rb <!-- .element: class="filename" -->
```ruby
Bookstore::Application.routes.draw do
  get 'register', to: 'users#new', as: 'register'
  resources :users
  root 'pages#home'
end
```

--

app/controllers/pages_controller.rb <!-- .element: class="filename" -->
```ruby
class PagesController < ApplicationController
  def home
  end
end
```

`app/views/pages/home.html.erb` created
```bash
rspec spec/controllers/users_controller_spec.rb
6 examples, 0 failures

rspec spec/features/registration_spec.rb
Failure/Error: expect(page).to have_content 'Sign out'
  expected to find text "Sign out" in ""
```
<!-- .element: class="command-line" data-output="2-3,5-6"-->

---

# Fix expected to find text <br> 'Sign out'

app/views/lououts/application.html.erb <!-- .element: class="filename" -->
```html
# ...
<body>
  <%- if session[:user_id].present? %>
    <%= link_to 'Sign out', '#' %>
  <%- else %>
    <%= link_to 'Sign up', register_path %>
  <%- end %>

  <%= yield %>
</body>
# ...
```

```bash$
rspec spec/features/registration_spec.rb
Failure/Error: expect(page).to have_content 'You registered'
  expected to find text "You registered" in "Sign out"
```
<!-- .element: class="command-line" data-output="2-3"-->

---

# Fix expected to find text <br> 'You registered'

app/views/lououts/application.html.erb <!-- .element: class="filename" -->
```html
# ...
<body>
  # ...
  <% if flash[:notice].present? %>
    <div id="notice"><%= flash[:notice] %></div>
  <% end %>
  # ...
</body>
# ...
```

```bash
rspec spec/features/registration_spec.rb
1 example, 0 failures
```
<!-- .element: class="command-line" data-output="2"-->

---

# Homework

You need to write a simple web book store. Please implement the following user stories.

<!-- .element: style="display: block; text-align: left" -->

* An administrator can add/edit/delete books.
* An administrator can add/edit/delete categories.
* An administrator can add/edit/delete authors.
* An administrator can connect books to categories and authors.
* A user can navigate the site by categories.
* A user can search for books by author, title.
* A user can view detailed information on a book. For example, number of pages, publication date, author and a brief
description.
* A user can put books into a "shopping cart" and buy them when he is done shopping.
* A user can remove books from his cart before completing an order.
* To buy a book the user enters his billing address, the shipping address and credit card information.
* A user can rate and review books.
* An administrator needs to approve or reject reviews before they're available on the site.
* A user can establish an account that remembers shipping and billing information.
* A user can edit his account information (credit card, shipping address, billing address and so on).
* A user can put books into a "wish list" that is visible to other site visitors.
* A user can check the status of his recent orders.
* A user can view a history of all of his past orders.
