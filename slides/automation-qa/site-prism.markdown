---
layout: slide
title:  SitePrism
---

# SitePrism/Page Object

---

# What is SitePrism?

A Page Object Model DSL for Capybara

It is gem that provides you describe object model page on any elements or methods and comfortable use it with Capybara in automated acceptance testing.

---

# What is Page Object Model?

It's a test automation pattern that aims to create an abstraction of your site's user interface that can be used in tests. The most common way to do this is to model each page as a class, and to then use instances of those classes in your tests.

If a class represents a page then each element of the page is represented by a method that, when called, returns a reference to that element that can then be acted upon (clicked, set text value), or queried (is it enabled? / visible?).

---

# Installation

Gemfile <!-- .element: class="filename" -->

```ruby
group :test do
  gem 'capybara'
  gem 'webdrivers'
  gem 'site_prism'
end
```

Bash <!-- .element: class="filename" -->

```bash
$ bundle install
```

---

# Setup config

You also need to require `capybara` or `capybara/cucumber` to use `site_prism`

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
require 'capybara'
require 'capybara/rspec'
require 'webdrivers'
require 'site_prism'
```

You need to require all files from `/spec/support`, to keep there all rspec configs

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
 Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
```

--

## Set Capybara driver

spec/support/configs/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.register_driver :site_prism do |app|
  browser = ENV.fetch('browser', 'firefox').to_sym
  Capybara::Selenium::Driver.new(app, browser: browser, desired_capabilities: capabilities)
end

Capybara.configure do |config|
  config.default_driver = :site_prism
end
```

If you already have config driver such as: selenium(by default), chrome or any else, you can use them.

---

## Creating your first Page Object

spec/support/pages/home_page.rb <!-- .element: class="filename" -->

```ruby
class HomePage < SitePrism::Page
end
```

---

## Add URL

spec/support/pages/home_page.rb <!-- .element: class="filename" -->

```ruby
class HomePage < SitePrism::Page
  set_url 'http://www.mysite.com/home.htm'
end
```

If you've set Capybara's app_host then you can set the URL as follows:

spec/support/pages/home_page.rb <!-- .element: class="filename" -->

```ruby
class HomePage < SitePrism::Page
  set_url '/home.htm'
end
```

Note: The setting a URL is optional, only need to use this when you want to navigate directly to that page.

--

## URL with params

SitePrism uses the `addressable` gem that allows works with params of URLs

spec/support/pages/user_profile_page.rb <!-- .element: class="filename" -->

```ruby
class UserProfilePage < SitePrism::Page
  set_url '/users/{user_id}'
end
```

or

```ruby
class SearchPage < SitePrism::Page
  set_url '/search{?query*}'
end
```

--

## Navigate directly to the page using `#load`

```ruby
  context 'test' do
    let(:user_profile_page) { UserProfilePage.new }

    before do
      user_profile_page.load # loads /users
      user_profile_page.load(user_id: 1) # loads /users/1
    end
  end
```

```ruby
context 'test' do
  let(:user_search_page) { SearchPage.new }

  before do
    user_search_page.load(query: 'simple') # loads /search?query=simple
    user_search_page.load(query: {'color' => 'red', 'text' => 'blue'}) # loads /search?color=red&text=blue
  end
end
```

--

## Check page

Calling `#displayed?` will return true if the browser's current URL matches the page's template and false if it doesn't.

```ruby
  context 'test' do
    let(:user_profile_page) { UserProfilePage.new }

    before do
      user_profile_page.load # loads /users
      user_profile_page.load(user_id: 1) # loads /users/1
    end

    it 'test' do
      expect(user_profile_page).to be_displayed
      expect(user_profile_page).to be_displayed(id: 1)
    end
  end
```

--

If passing options to `#displayed?` isn't powerful enough to meet your needs, you can directly access and assert on the `#url_matches` found when comparing your page's URL template to the current_url:

```ruby
context 'test' do
  let(:user_search_page) { SearchPage.new }

  before do
    user_search_page.load(query: 'simple') # loads /search?query=simple
    user_search_page.load(query: {'color' => 'red', 'text' => 'blue'}) # loads /search?color=red&text=blue
  end

  it 'test' do
    expect(user_search_page.url_matches['query']['color']).to eq('red')
  end
end
```

Also you can use `expect(page).not_to` ...

--

## Current Page's URL

```ruby
context 'test' do
  let(:user_search_page) { SearchPage.new }

  before do
    user_search_page.load(query: 'simple') # loads /search?query=simple
    user_search_page.load(query: {'color' => 'red', 'text' => 'blue'}) # loads /search?color=red&text=blue
  end

  it 'test' do
    user_search_page.current_url #=> "http://www.example.com/search?color=red&text=blue"
    expect(user_search_page.current_url).to include('example.com/search')
  end
end
```

---

## HTTP vs. HTTPS

You can check is page secure(https) or not(http)

```ruby
page.secure? #=> true/false
expect(page).to be_secure
expect(page).not_to be_secure
```

---

# Elements

SitePrism helps you divide any elements page and keep it in PageObject.

--

## Method `#element`

To create element of page:

```ruby
class HomePage < SitePrism::Page
  element :search_field, 'input[name="q"]'
end
```

The method `#element` takes 2 arguments: the name of the element as a symbol, and a css selector as a string.

--

## How to search field

```ruby
home_page.load

home_page.search_field # will return the capybara element found using the selector
home_page.search_field.set 'the search string' # `search_field` returns a capybara element, so use the capybara API to deal with it
home_page.search_field.text # standard method on a capybara element; returns a string
```

--

## Testing for the existence of the element

element method is the has_<element_name>? method

```ruby
home_page.load
home_page.has_search_field? # returns true if it exists, false if it doesn't
```

```ruby
it "text" do
  expect(home_page).to have_search_field
end
```

--

## Testing that an element does not exist

```ruby
home_page.load
home_page.has_no_search_field? #=> returns true if it doesn't exist, false if it does
```

```ruby
it "text" do
  expect(home_page).to have_no_search_field #NB: NOT => expect(@home).not_to have_search_field
end
```

--

## Waiting for an element to become visible

`#wait_until_<element_name>_visible` method

```ruby
home_page.wait_until_search_field_visible
# or...
home_page.wait_until_search_field_visible(wait: 10)
```
or `#wait_until_<element_name>_invisible` method
```ruby
home_page.wait_until_search_field_invisible
# or...
home_page.wait_until_search_field_invisible(wait: 10)
```

--

## CSS Selectors vs. XPath Expressions

All use CSS selectors to find elements, it is possible to use XPath expressions too. In SitePrism, everywhere that you can use a CSS selector, you can use an XPath expression.

```ruby
class HomePage < SitePrism::Page
  # CSS Selector
  element :first_name, 'div#signup input[name="first-name"]'

  # Identical selector as an XPath expression
  element :first_name, :xpath, '//div[@id="signup"]//input[@name="first-name"]'
end
```

---

## Element Collections

If you want to work with collection similar elements such as list of names, SitePrism provides the method `#elements`

```ruby
class FriendsPage < SitePrism::Page
  elements :names, 'ul#names li a'
end
```

The elements method takes 2 arguments: the first being the name of the elements as a symbol, the second is the css selector (Or locator strategy), that would return capybara elements.

--

You can access the element collection like this:

```ruby
friends_page.names # [<Capybara::Element>, <Capybara::Element>, <Capybara::Element>]
```

With that you can do all the normal things that are possible with arrays:

```ruby
friends_page.names.each { |name| puts name.text }
friends_page.names.map { |name| name.text }
```

In tests:

```ruby
expect(friends_page.names.map { |name| name.text }).to eq(['Alice', 'Bob', 'Fred'])
expect(friends_page.names.size).to eq(3)
```

--

## Testing for the existence of the element collection

To check on exists elements page use `#has_<element collection name>?` method:

```ruby
friends_page.has_names? #=> returns true if at least one `name` element is found
```

```ruby
it "text" do
  expect(friends_page).to have_names #=> This only passes if there is at least one `name`
end
```

--

## Waiting for the elements to be visible or invisible

`#wait_until_<elements_name>_visible` and `#wait_until_<elements_name>_invisible` methods:

```ruby
friends_page.wait_until_names_visible
# and...
friends_page.wait_until_names_invisible
```

```ruby
friends_page.wait_until_names_visible(wait: 5)
# and...
friends_page.wait_until_names_invisible(wait: 7)
```

--

## All mapped elements are present on the page

If you want to check on existing all elements on page, SitePrism provides you `#all_there?` method:

```ruby
friends_page.all_there? #=> true/false
```

```ruby
expect(friends_page).to be_all_there
```

--

Also you can have elements that not always is on your page, but you need to use `#all_there?`, you can declare `#expected_elements` method on your page object class that narrows the elements included in all_there?

```ruby
class TestPage < SitePrism::Page
  element :name_field, '#name'
  element :address_field, '#address'
  element :success_message, 'span.alert-success'

  expected_elements :name_field, :address_field
end
```

---

# Sections

SitePrism allows you to model sections of a page that appear on multiple pages or that appear a number of times on a page separately from Pages

--

## Individual Sections

In the same way that SitePrism provides element and elements, it provides section and sections. The first returns an instance of a page section, the second returns an array of section instances, one for each capybara element found by the supplied css selector. What follows is an explanation of section.

--

## Defining a Section

```ruby
class MenuPage < SitePrism::Section
end
```

--

## Add section to a Page

To add section to a page you need to call method `#section`. It takes 3 arguments:

1. name(naming section)
2. class(will be created instance that represent the page section)
3. `Capybara::Node::Finders`(Locator)

```ruby
class HomePage < SitePrism::Page
  section :menu, Menu, '#gbx3'
end
```

--

You can define a section as a class and/or an Anonymous section

```ruby
class People < SitePrism::Section
  element :footer, 'h4'
end

class Home < SitePrism::Page
  # section people_with_block will have `headline` and
  # `footer` elements in it
  section :people_with_block, People do
    element :headline, 'h2'
  end
end
```

--

## the page that includes the section

Section:

```ruby
class Menu < SitePrism::Section
end
```

The page that includes the section:

```ruby
class Home < SitePrism::Page
  section :menu, Menu, '#gbx3'
end
```

In tests:

```ruby
home_page = Home.new
home_page.menu #=> <MenuSection...>
```

--

## The following shows that though the same section can appear on multiple pages, it can take a different root node:

define the section that appears on both pages:

```ruby
class Menu < SitePrism::Section
end
```

define 2 pages, each containing the same section:

```ruby
class Home < SitePrism::Page
  section :menu, Menu, '#gbx3'
end

class SearchResults < SitePrism::Page
  section :menu, Menu, '#gbx48'
end
```

You can see that the Menu is used in both the Home and SearchResults pages, but each has slightly different root node. The capybara element that is found by the css selector becomes the root node for the relevant page's instance of the Menu section.

--

## Adding elements to a section

```ruby
class Menu < SitePrism::Section
  element :search, 'a.search'
  element :images, 'a.image-search'
  element :maps, 'a.map-search'
end
```

Add section to a page

```ruby
class Home < SitePrism::Page
  section :menu, Menu, '#gbx3'
end
```

--

## In tests

```ruby
home_page = Home.new
home_page.load

home_page.menu.search #=> returns a capybara element representing the link to the search page
home_page.menu.search.click #=> clicks the search link in the home page menu
home_page.menu.search['href'] #=> returns the value for the href attribute of the capybara element representing the search link
home_page.menu.has_images? #=> returns true or false based on whether the link is present in the section on the page
home_page.menu.wait_until_images_visible #=> waits for capybara's default wait time until the element is visible in the page section
```


```ruby
it "text" do
  expect(@home.menu).to have_search
  expect(@home.menu.search['href']).to include('google.com')
  expect(@home.menu).to have_images
  expect(@home.menu).to have_maps
end

or...

it "text" do
  @home.menu do |menu|
    expect(menu).to have_search
    expect(menu.search['href']).to include('google.com')
    expect(menu).to have_images
    expect(menu).to have_maps
  end
end
```

--

## Getting a section's parent

```ruby
class DestinationFilters < SitePrism::Section
  element :morocco, 'abc'
end

class FilterPanel < SitePrism::Section
  section :destination_filters, DestinationFilters, 'def'
end

class Home < SitePrism::Page
  section :filter_panel, FilterPanel, 'ghi'
end
```

In tests:

```ruby
home_page = Home.new
home_page.load

home_page.filter_panel.parent #=> returns home_page
home_page.filter_panel.destination_filters.parent #=> returns home_page.filter_panel
```

--

## Getting a section's parent


```ruby
class Menu < SitePrism::Section
  element :search, 'a.search'
  element :images, 'a.image-search'
  element :maps, 'a.map-search'
end

class Home < SitePrism::Page
  section :menu, Menu, '#gbx3'
end
```

In tests:

```ruby
home_page = Home.new
home_page.load
home_page.menu.parent_page #=> returns home_page
```

--

## Testing for the existence of a section

The section can check on exists with method `#has_<section name>?`

```ruby
class Menu < SitePrism::Section
  element :search, 'a.search'
  element :images, 'a.image-search'
  element :maps, 'a.map-search'
end

class Home < SitePrism::Page
  section :menu, Menu, '#gbx3'
end
```

```ruby
home_page = Home.new
#...
home_page.has_menu? #=> returns true or false
```

```ruby
expect(home_page).to have_menu
expect(home_page).not_to have_menu
```

--

## Sections within sections

you can nest sections within sections within sections within sections!

```ruby
# define a page that contains an area that contains a section for both
# logging in and registration. Modelling each of the sub-sections separately

class Login < SitePrism::Section
  element :username, '#username'
  element :password, '#password'
  element :sign_in, 'button'
end

class Registration < SitePrism::Section
  element :first_name, '#first_name'
  element :last_name, '#last_name'
  element :next_step, 'button.next-reg-step'
end

class LoginRegistrationForm < SitePrism::Section
  section :login, Login, 'div.login-area'
  section :registration, Registration, 'div.reg-area'
end

class Home < SitePrism::Page
  section :login_and_registration, LoginRegistrationForm, 'div.login-registration'
end
```

--

## In tests

how to login (fatuous, but demonstrates the point):

```ruby
it 'login'
  home_page = Home.new
  home_page.load
  expect(home_page).to have_login_and_registration
  expect(home_page.login_and_registration).to have_username
  home_page.login_and_registration.login.username.set 'bob'
  home_page.login_and_registration.login.password.set 'p4ssw0rd'
  home_page.login_and_registration.login.sign_in.click
end
```

how to sign up:

```ruby
it 'sign up' do
  home_page = Home.new
  home_page.load
  expecthome_page.login_and_registration).to have_first_name
  expecthome_page.login_and_registration).to have_last_name
  home_page.login_and_registration.first_name.set 'Bob'
  # ...
end
```

--

## Anonymous Sections

If you want to use a section more as a namespace for elements and are not planning on re-using it, you may find it more convenient to define an anonymous section using a block:

```ruby
class Home < SitePrism::Page
  section :menu, '.menu' do
    element :title, '.title'
    elements :items, 'a'
  end
end
```

In tests:

```ruby
home_page = Home.new
expect(home_page.menu).to have_title
```

---

## Load Validations

Load validations enable common validations to be abstracted and performed on a Page or Section to determine when it has finished loading and is ready for interaction in your tests

--

## Using Load Validations

Load validations can be used in three constructs:

1. Passing a block to `Page#load`
2. Passing a block to `Loadable#when_loaded`
3. Calling `Loadable#loaded?`

--

## Page#load

When a block is passed to the Page#load method, the url will be loaded normally and then the block will be executed within the context of when_loaded. See when_loaded documentation below for further details.

```ruby
# Load the page and then execute a block after all load validations pass:
my_page_instance.load do |page|
  page.do_something
end
```

--

## Loadable#when_loaded

The Loadable#when_loaded method on a Loadable class instance will yield the instance of the class into a block after all load validations have passed.

If any load validation fails, an error will be raised with the reason, if given, for the failure.

```ruby
# Execute a block after all load validations pass:
a_loadable_page_or_section.when_loaded do |loadable|
  loadable.do_something
end
```

--

## Loadable#loaded?

You can explicitly run load validations on a Loadable via the loaded? method. This method will execute all load validations on the object and return a boolean value. In the event of a validation failure, a validation error can be accessed via the load_error method on the object, if any error message was emitted by the failing validation.

```ruby
it 'loads the page' do
  some_page.load
  some_page.loaded?    #=> true if/when all load validations pass
  another_page.loaded? #=> false if any load validations fail
  another_page.load_error #=> A string error message if one was supplied by the failing load validation, or nil
end
```

--

## Defining Load Validations

A load validation is a block which returns a boolean value when evaluated against an instance of the Page or Section where defined.

```ruby
class SomePage < SitePrism::Page
  element :foo_element, '.foo'
  load_validation { has_foo_element? }
end
```

with current error:

```ruby
class SomePage < SitePrism::Page
  element :foo_element, '.foo'
  load_validation { [has_foo_element?, 'did not have foo element!'] }
end
```

--

## Skipping load Validations

Defined load validations can be skipped for one load call by passing in `with_validations: false`.

```ruby
it 'loads the page without validations' do
  some_page.load(with_validations: false)
  some_page.loaded?    #=> true unless something has gone wrong
end
```

--

## Load Validation Inheritance and Execution Order

Any number of load validations may be defined on a Loadable and they are inherited by its subclasses (if any exist).

```ruby
class BasePage < SitePrism::Page
  element :loading_message, '.loader'

  load_validation do
    [has_no_loading_message?(wait: 10), 'loading message was still displayed']
  end
end

class FooPage < BasePage
  set_url '/foo'

  section :form, '#form'
  element :some_other_element, '.myelement'

  load_validation { [has_form?, 'form did not appear'] }
  load_validation { [has_some_other_element?, 'some other element did not appear'] }
end
```

--

In the above example, when loaded? is called on an instance of FooPage, the validations will be performed in the following order:

1. The `BasePage` validation will wait for the loading message to disappear.
2. The `FooPage` validation will wait for the form element to be present.
3. The `FooPage` validation will wait for the some_other_element element to be present.

---

## For more information about SitePrism see:

https://github.com/site-prism/site_prism#accessing-a-pages-section

---

# The End
