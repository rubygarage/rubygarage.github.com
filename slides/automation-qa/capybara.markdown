---
layout: slide
title: Capybara
---

# What is Capybara?

DSL extensions for testing web-based UIs
- HTML elements and attributes
- CSS classes
- Javascript calls

---

# Why Capybara Gem?

Capybara can mimic actions of real users interacting with web-based applications. It can receive pages, parse the HTML and submit forms.

Capybara supports many different drivers which execute your tests through the same clean and simple interface. You can seamlessly choose between Selenium, Webkit or pure Ruby drivers.

---

# Install Capybara

--

The first thing we need to do is add our gem to Gemfile in `:test` group

```ruby
group :test do
  gem "capybara"
  gem "rspec-rails"
  gem "selenium-webdriver" # in order to use Selenium
end
```

Then, run `bundle install` to download and install new gem

```bash
$ bundle install
```

Define config file:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
require 'capybara/rails'
```

We need include a support folder for rspec. Add following line down the file rails_helper.rb this will tell rails to load the modules under the `spec/support`.

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |file| require file }
```

---

# Capybara configuration

--

## Configure Capybara to suit your needs.

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.configure do |config|
  config.run_server = false                   # Whether to start a Rack server for the given Rack app, default = true
  config.session_name = "some other session"  # Set name for the current session
  config.server = :puma, { Silent: true }     # To clean up your test output
  config.default_max_wait_time = 5            # The maximum number of seconds to wait for asynchronous processes to finish
end
```

- Configurable options

  - You can find full list of options [here](https://www.rubydoc.info/github/jnicklas/capybara/Capybara.configure)

- DSL Options

  - `default_driver` - The name of the driver to use by default.

  - `javascript_driver` - The name of a driver to use for JavaScript enabled tests.


--

## Execution host

Normally Capybara expects to be testing an in-process Rack application, but you can also use it to talk to a web server running anywhere on the internet, by setting app_host:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
  Capybara.current_driver = :selenium # Default driver (:rack_test) does not support running against a remote server.
  Capybara.app_host = 'http://www.google.com'
```

After previous execution write:

spec/features/test_spec.rb <!-- .element: class="filename" -->

```ruby
visit('/') # Capybara will visit `http://www.google.com`
```

--

## Launch different browsers



---

# Drivers

--

By default, Capybara uses the `:rack_test` driver which does not have any support for executing JavaScript.
Drivers can be switched in Before and After blocks. Some of the web drivers supported by Capybara are mentioned below.

- Non JS support
  - RackTest (out from box, using in API testing)

- With JS support
  - Selenium-Webdriver

  - Apparition

  - Capybara-Webkit

--

## RackTest

By default, it works with rack::test driver. This driver is considerably faster than other drivers, but it lacks JavaScript support and it cannot access HTTP resources outside of the application for which the tests are made (Rails app, Sinatra app).

--

## Selenium

Capybara supports selenium-webdriver, which is mostly used in web-based automation frameworks. It supports JavaScript, can access HTTP resources outside of application, and can also be setup for testing in headless mode which is especially useful for CI scenarios.

Capybara pre-registers a number of named drivers that use Selenium - they are:

- `:selenium` => Selenium driving Firefox

- `:selenium_headless` => Selenium driving Firefox in a headless configuration

- `:selenium_chrome` => Selenium driving Chrome

- `:selenium_chrome_headless` => Selenium driving Chrome in a headless configuration

--

## Apparition

The apparition driver is a new driver that allows you to run tests using Chrome in a headless or headed configuration. It attempts to provide backwards compatibility with the [Poltergeist driver API](https://github.com/teampoltergeist/poltergeist) and [capybara-webkit API](https://github.com/thoughtbot/capybara-webkit) while allowing for the use of modern JS/CSS. It uses CDP to communicate with Chrome, thereby obviating the need for chromedriver. This driver is being developed by the current developer of Capybara and will attempt to keep up to date with new Capybara releases. It will probably be moved into the teamcapybara repo once it reaches v1.0.

--

## Capybara-Webkit

For true headless testing with JavaScript support, we can use the [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) driver (gem). It uses QtWebKit and it is significantly faster than selenium as it does not load the entire browser.

--

## Selecting the Driver

For example if you'd prefer to run everything in Selenium, you could do:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.default_driver = :selenium # :selenium_chrome and :selenium_chrome_headless are also registered
```

--

## Configuring and adding drivers

Capybara makes it convenient to switch between different drivers. It also exposes an API to tweak those drivers with whatever settings you want, or to add your own drivers. This is how to override the selenium driver configuration to use chrome:

```ruby
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
```

The [Selenium wiki](https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings) has additional info about how the underlying driver can be configured.

--

## `type: :feature`

Feature specs are marked by `type: :feature` or if you have set
`config.infer_spec_type_from_file_location!` by placing them in `spec/features`.

spec/features/test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'some test placed in features folder' do
end
```

or

spec/test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'some test with type feature', type: :feature do
end
```

--

## `js: true`

Use `js: true` to switch to the `Capybara.javascript_driver` (:selenium by default), or provide a :driver option to switch to one specific driver. For example:

spec/features/test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'some stuff which requires js', type: :feature, js: true do
  it 'will use the default js driver'
end
```

spec/features/second_test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'some stuff which not requires js', type: :feature do
  it 'will use the default driver'
end
```

---

# Finders

--

### How to find elements? - DOM

The `Document Object Model` (DOM) is a cross-platform and language-independent interface that treats an XML or HTML document as a tree structure wherein each node is an object representing a part of the document. The DOM represents a document with a logical tree. Each branch of the tree ends in a node, and each node contains objects.

`Finders` - Capybara provided methods whereby you can find specific elements in DOM, in order to manipulate them.

```ruby
find_field(name: 'name_of_field')
find_field(id: 'my_field_id')
find_link('link_name', :visible => :all)
find_link(class: ['some_class', 'some_other_class'], :visible => :all)

find_button(text: 'some_name')
find_button(value: 'some_value')

find(:xpath, './/table/tr')
find('#overlay').find('h1')
find('.person')

all('a', text: 'Home')
all('a#person_123')
```

More about different types of finder you can find [here](https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Finders) and [here](https://gist.github.com/tomas-stefano/6652111)

--

### Ambiguous match error

When you trying to find an element, it is common to have two or more matches which will cause Capybara to fail with an Ambiguous match error. For this case you can use next methods:

- `:one` – raises an error when more than one match found

- `:first` – simply picks the first match

---

# Actions

--

## How to click/hover/any other action with element?

 Capybara is a gem built to be used on top of an underlying web-based driver. It offers a user-friendly `DSL` (Domain Specific Language) which is used to describe actions that are executed by the underlying web driver.

--

### Basic `DSL`

`Note`: By default Capybara will only locate visible elements. This is because a real user would not be able to interact with non-visible elements.

Capybara comes with a very intuitive DSL which is used to express actions that will be executed. This is the list of basic command that are used

```ruby
click_link('id_of_link') # click link by id
click_link('link_name') # click link by link text
click_button('button_text') # click button by button text

fill_in('field_name', with: 'your_value') # fill text field

choose('radio_button_name') # choose radio button
check('checkbox_id') # check in checkbox
uncheck('checkbox_name') # uncheck in checkbox

select('option', from: 'select_box_name') # select from dropdown

attach_file('image_name', 'path_to_image') # upload file

find('.some_class').hover # finds the desired element and simulate mouse hover
```

```ruby
# For the duration of the block, any command to Capybara will be handled as though it were scoped to the given element.
within("some_class") do
  fill_in('field_name', with: 'your_value')
  fill_in('field_name_2', with: 'your_value_2')
end
```

--

## `Visit`

Visit method allows you navigate to the given [**URL**](https://rubygarage.github.io/slides/qa-automation/rails-structure#/9/5) or [**Path**](https://rubygarage.github.io/slides/qa-automation/rails-structure#/9/5) Helpers

```ruby
visit("/users")   # navigate to page with users through URL

visit(users_path) # navigate to page with users through Path

# In both cases we will visit page with users (https://your_facebook/users)
```

Also you can provide params for visit method

```bash
user.id
=> 1
```

```ruby
visit("/users/#{user}")  # navigate to page with user through URL

visit(user_path(user))   # navigate to page with user through Path

# In both cases we will visit page with user_id = 1 (https://your_facebook/users/1)
```

--

### Advanced `DSL`

For scenarios where basic the DSL cannot help, we use xpath and CSS selectors (CSS selectors will be used by default). This is very common, since modern web applications usually have a lot of JavaScript code that generates HTML elements with attributes that have generated values (like random ids, etc.)

To find a specific element and click on it we can use:

spec/features/test_spec.rb <!-- .element: class="filename" -->

```ruby
find('xpath/css').click
```

To use xpath selectors, simply change the following configuration value:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.default_selector = :xpath
```

The selector type can be specified, if necessary:

```ruby
find(:xpath, 'actual_xpath')
```

---

# Matchers

--

### Capybara provides special matchers for our RSpec Expectations

Capybara has a rich set of options for querying the page for the existence of certain elements, and working with and manipulating those elements.

```ruby
expect(page).to have_selector('table tr')
expect(page).to have_selector(:xpath, './/table/tr')

expect(page).to have_xpath('.//table/tr')
expect(page).to have_css('table tr.foo')
expect(page).to have_content('foo')
expect(page).to have_no_content('foo')
expect(page).to have_current_path(your_path)
expect(page).to have_link("Foo", :href=>"googl.com")
expect(page).to have_no_link("Foo", :href=>"google.com")
expect(page).to have_field('#field')
expect(page).to have_button('#submit')
```

---

# Debugging

--

It can be useful to take a snapshot of the page as it currently is and take a look at it:

```ruby
save_and_open_page
```

You can also retrieve the current state of the DOM as a string using `page.html.`

```ruby
print page.html
```

Finally, in drivers that support it, you can save a screenshot:

```ruby
save_and_open_screenshot
```

Screenshots are saved to `Capybara.save_path`, relative to the app directory. If you have required `capybara/rails`, `Capybara.save_path` will default to `tmp/capybara`.
