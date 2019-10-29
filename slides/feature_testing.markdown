---
layout: slide
title:  Feature testing
---

# Feature testing

  Feature(integration) testing this is testing part of the program(feature) in which user behavior is simulated

---

## The difference between `unit` testing and `feature`

--

![](/assets/images/unit-vs-integration-tests.jpeg)

**`Unit`** tests are needed to test individual sections of the program such as method, class, service, etc.

**`Feature`** tests are needed to verify the interaction of program components with each other
---

# Init testing tools

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
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'ffaker'
end
...
```

```bash
bundle install
```
<!-- .element: class="command-line" -->

--

## Init RSpec

```bash
$ rails g rspec:install
```
<!-- .element: class="command-line" data-output="2-4"-->

config/application.rb <!-- .element: class="filename" -->
```ruby
config.generators do |g|
  g.test_framework :rspec
end
```

spec/rails_helper.rb <!-- .element: class="filename" -->
```ruby
require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
```
Transactional fixtures simply wrap each test in a database transaction and start a rollback at the end of it, reverting the database back to the state it was in before the test. 

--

## It is considered good practice to transfer gem settings from the `rails_helper` to the support folder

add the line below to your `rails_helper.rb` 


```ruby
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
```

Now we can add gem settings to a folder `spec/support` and they automatically connect.

--

### Add Capybara settings: 

spec/support/capybara.rb <!-- .element: class="filename" -->
```ruby
require 'capybara/rspec'
require 'webdrivers/chromedriver'

Capybara.default_driver = :selenium_chrome
```

### The same for shoulda matchers

spec/support/shoulda_matchers.rb <!-- .element: class="filename" -->
```ruby
require 'shoulda/matchers'
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

---

# FFaker

--

## FFaker is a gem that allows you to generate fake data.

example:
```ruby
FFaker::Name.name     #=> "Christophe Bartell"
```

more about Faker [here](https://github.com/ffaker/ffaker).

---

# Factory bot

--

### This is a gem that allows you to easily create entities for testing. It works great with a `ffaker`.

In order to create entities for testing, you first need to define a factory. 
See below user factory example:

spec/factories/users.rb <!-- .element: class="filename" -->
```ruby
FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end
end
```

It is very important to observe the correct naming since the factory is trying to create an entity based on the model. The factory that we created before that will create instances of the `User` class
--

# Factory call

```ruby
build(:user)
```
Such a call would be equivalent to this
```ruby
 User.new(email: FFaker::Internet.email, password: FFaker::Internet.password)
```

--

# Trait

### Trait allows you to create factories with additional data for special cases.

for example, create an additional column `name` in the model `User`. Now our factory call will look like this:

rails c <!-- .element: class="filename" -->
```bash
<User:0x00007fc3082fabe8> {
                        :id => nil,
                        :name => "",
                        :email => "Richard123@example.com",
                        :password => "123456"
                     }
```

--

### Add trait to your factory:

spec/factories/users.rb <!-- .element: class="filename" -->
```ruby
FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end

  trait :with_name do
    name { FFaker::Name.name }
  end
end
```
after adding trait you can call factory with him
```ruby
build(:user, :with_name)
```
output:
```bash
<User:0x00007fc3082fabe8> {
                        :id => nil,
                        :name => "Richard Gear",
                        :email => "Richard123@example.com",
                        :password => "123456"
                     }
```
---

# Meet the Capybara

--

![](/assets/images/bdd/capybara.jpg) <!-- .element: style="width: 700px" -->

`Capybara` is acceptance test framework for web applications.

Capybara helps to test web applications by simulating how a real user would interact with an app.

Test your app with [Capybara](https://github.com/teamcapybara/capybara)

--

## Capybara Drivers

By default, Capybara uses the ```:rack_test``` driver, which is fast but limited: it does not support JavaScript, nor is it able to access HTTP resources outside of your Rack application, such as remote APIs and OAuth services. To get around these limitations, you can set up a different default driver for your features.
```ruby
Capybara.default_driver = :selenium
```
- `:selenium` => Selenium driving Firefox
- `:selenium_headless` => Selenium driving Firefox in a headless configuration
- `:selenium_chrome` => Selenium driving Chrome
- `:selenium_chrome_headless` => Selenium driving Chrome in a headless configuration

In order to use Selenium, you'll need to install the `selenium-webdriver` gem.

---

# Page Objects with SitePrism

--

## SitePrism

 [SitePrism](https://github.com/site-prism/site_prism) gives you a simple, clean and semantic DSL for describing your site using the Page Object Model pattern, for use with Capybara in automated acceptance testing.

--

## Page Object Model
  The Page Object Model is a test automation pattern that aims to create an abstraction of your site's user interface that can be used in tests. 
  
  The most common way to do this is to model each page as a class, and to then use instances of those classes in your tests.

--

## Setup SitePrism

Add gem to gemfile
```ruby
  gem 'site_prism'
```

If you're using rspec instead, here's what needs requiring:
```ruby
require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
```

--

## Usage example:

define the page object:

/spec/support/pages/sign_up_page.rb<!-- .element: class="filename" -->
```ruby
class SignUpPage < SitePrism::Page
  element :user_email_field, "input[id='user_email']"
  element :user_password_field, "input[id='user_password']"
  element :user_password_confirmation_field, "input[id='user_password_confirmation']"
  set_url '/users/sign_up'

  def sign_up(useremail, password, confirm_password = password)
    user_email_field.set(useremail)
    user_password_field.set(password)
    user_password_confirmation_field.set(confirm_password)
    click_on(I18n.t('user.registration.sign_up'))
  end
end
```
--

## Add page object to spec:

```ruby
RSpec.describe 'Sign up', type: :feature do
  let(:sign_up_page) { SignUpPage.new }
  let(:user_attrs) { attributes_for(:user) }

  before{ sign_up_page.load }
  
  scenario 'succsessful sign up' do
    sign_up_page.sign_up(user_attrs[:email], user_attrs[:password])
    expect(User.count).to eq(1)
  end
end
```

--

## The same test, but without page object

```ruby
RSpec.describe 'Sign up', type: :feature do
  let(:user_attrs) { attributes_for(:user) }

  before { visit sign_up_path }

  it 'User try to sign up with valid data' do
    expect(page).to have_content I18n.t('devise.sign_up')
    within('.general-form') do
      fill_in 'user_email', with: user_attrs[:email]
      fill_in 'user_password', with: user_attrs[:password]
      fill_in 'user_password_confirmation', with: user_attrs[:password]
    end
    click_on(I18n.t('user.registration.sign_up'))
    expect(User.count).to eq(1)
  end
end
```

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

![](/assets/images/bdd/bdd-cycle-around-tdd-cycles.png)

1. Start with an Acceptance Test scenario.
2. Run the Acceptance Test scenario.
3. Red/Green/Refactor with Unit Tests.
  * View
  * Controller
  * Model
4. Run the Acceptance Test scenario again.

---

# BDD example

--

## User story:

Sign up

On this page are placed:
Email, Password and
Sign up button.

Given The user is a guest
When he wants to register a new account
And he clicks the Sign up link.

When the user wants to register a new account using Email
And the user enters his email address into the Email field,
And enters a password into the Password field,
Then he clicks the Sign Up button 
And a new account will be created, the user will be logged in.

--

# Registration feature

spec/features/registration_spec.rb <!-- .element: class="filename" -->

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

--

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

--

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

--

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

--

# Fix missing template 'users/new'

`app/views/users/new.html.erb` created

```bash
rspec spec/features/registration_spec.rb
Capybara::ElementNotFound:
  Unable to find css "#new_user"
```
<!-- .element: class="command-line" data-output="2-3"-->


--

# Fix the action 'create' could not be found error

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

--

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

--

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

--

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

# Controller specs

spec/controllers/users_controller_spec.rb <!-- .element: class="filename" -->
```ruby
describe UsersController do
  describe 'GET new' do
    let(:user) { double("User") }

    before do
      allow(User).to receive(:new).and_return(user)
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
RSpec.describe User, type: :model do
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

--

## Model spec by shoulda matchers

spec/models/user_spec.rb <!-- .element: class="filename" -->
```ruby
RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
end
```

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
