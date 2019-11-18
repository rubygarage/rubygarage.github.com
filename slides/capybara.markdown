---
layout: slide
title: Capybara
---

## What is Capybara?

DSL extensions for testing web-based UIs
- HTML elements and attributes
- CSS classes
- Javascript calls

---

## Why Capybara Gem?
- **Commands**
  - visit
  - click
  - within
  - ...

- **Matchers**
  - have_selector
  - have_content
  - have_no_content
  - ...

- **Complexities working with Javascript**
  - different web drivers for different tasks

- **Debugging**
  - save_and_open_page
  - save_and_open_screenshot

---

## Install `Capybara`

The first thing we need to do is add our gem to Gemfile in `:development, :test` groups

```ruby
group :development, :test do
  gem "capybara"
  gem "rspec-rails"
end
```

Then, run `bundle` to download and instal new gem

```bash
$ bundle install
```

After that we must require `capybara` to test helper file. 

For this we will crete new folder spec/`support`. And `capybara.rb` file in it.

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
require 'capybara/rails'
```

Just the following line down the file `rails_helper.rb`

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }
```

---

## Capybara configuration 

Configure Capybara to suit your needs.

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.configure do |config|
  config.run_server = false
  config.app_host   = 'http://www.google.com'
  config.session_name = "some other session"
  config.server = :puma, { Silent: true } # To clean up your test output
end
```

- Configurable options

  - You can find full list of options [here](https://www.rubydoc.info/github/jnicklas/capybara/Capybara.configure)

- DSL Options

  - `default_driver (Symbol = :rack_test)` - The name of the driver to use by default.

  - `javascript_driver (Symbol = :selenium)` - The name of a driver to use for JavaScript enabled tests.

---

## Drivers

By default, Capybara uses the `:rack_test` driver which does not have any support for executing JavaScript. 
Drivers can be switched in Before and After blocks. Some of the web drivers supported by Capybara are mentioned below.

- Non JS support
  - RackTest (out from box, using in API testing)

- With JS support
  - Selenium-Webdriver

  - Apparition

  - Capybara-Webkit

  - Poltergeist

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

## Poltergeist

Poltergeist is a PhantomJS driver for Capybara. We can use the [poltergeist](https://github.com/teampoltergeist/poltergeist) driver (gem). PhantomJS is a headless WebKit scriptable with a JavaScript API. It has fast and native support for various web standards: DOM handling, CSS selector, JSON, Canvas, and SVG.

---

## Selecting the Driver

For example if you'd prefer to run everything in Selenium, you could do:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.default_driver = :selenium # :selenium_chrome and :selenium_chrome_headless are also registered
```

You can also change the driver temporarily (typically in the Before/setup and After/teardown blocks):

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.current_driver = :apparition # temporarily select different driver
# tests here
Capybara.use_default_driver       # switch back to default driver
```

`Note`: switching the driver creates a new session, so you may not be able to switch in the middle of a test.

---

## Configuring and adding drivers

Capybara makes it convenient to switch between different drivers. It also exposes an API to tweak those drivers with whatever settings you want, or to add your own drivers. This is how to override the selenium driver configuration to use chrome:

```ruby
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
```

The [Selenium wiki](https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings) has additional info about how the underlying driver can be configured.

---

### `js: true`

Use `js: true` to switch to the `Capybara.javascript_driver` (:selenium by default), or provide a :driver option to switch to one specific driver. For example:

spec/feature/test_spec.rb <!-- .element: class="filename" -->

```ruby
describe 'some stuff which requires js', js: true do
  it 'will use the default js driver'
  it 'will switch to one specific driver', driver: :apparition
end
```

---

## Execution host

Normally Capybara expects to be testing an in-process Rack application, but you can also use it to talk to a web server running anywhere on the internet, by setting app_host:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
  Capybara.current_driver = :selenium # Default driver (:rack_test) does not support running against a remote server.
  Capybara.app_host = 'http://www.google.com'
```

After previous execution if you write `visit('/')` in your feature test, your Capybara will visit `http://www.google.com`.

Also you can visit any URL directly:

spec/feature/test_spec.rb <!-- .element: class="filename" -->

```ruby
visit('http://www.youtube.com')
```

By default Capybara will try to boot a rack application automatically. You might want to switch off Capybara's rack server if you are running against a remote application:

spec/support/capybara.rb <!-- .element: class="filename" -->

```ruby
Capybara.run_server = false
```

---

### How to find elements? - DOM

`Finders` - Capybara provided methods whereby you can find specific elements, in order to manipulate them.

```ruby
find_field('First Name').value
find_field(id: 'my_field').value
find_link('Hello', :visible => :all).visible?
find_link(class: ['some_class', 'some_other_class'], :visible => :all).visible?

find_button('Send').click
find_button(value: '1234').click

find(:xpath, ".//table/tr").click
find("#overlay").find("h1").click
all('a').each { |a| a[:href] }
```

More about different types of finder you can find [here](https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Finders)

--

### Ambiguous match error

When trying to find an element either using the DSL or xpath/CSS selectors, it is common to have two or more matches which will cause Capybara to fail with an Ambiguous match error. For this case you can use next methods:

- `:one` – raises an error when more than one match found

- `:first` – simply picks the first match

- `:prefer_exact` – finds all matching elements, but will return only an exact match discarding other matches

- `:smart` – depends on the value for Capybara.exact. If set to true, it will behave like :one. Otherwise, it will first search for exact matches. If multiple matches are found, an ambiguous exception is raised. If none are found, it will search for inexact matches and again raise an ambiguous exception when multiple inexact matches are found.

---

## How to click/hover/any other action with element?

### Capybara is a library/gem built to be used on top of an underlying web-based driver. It offers a user-friendly `DSL` (Domain Specific Language) which is used to describe actions that are executed by the underlying web driver.

--

### Basic `DSL`

`Note`: By default Capybara will only locate visible elements. This is because a real user would not be able to interact with non-visible elements.

Capybara comes with a very intuitive DSL which is used to express actions that will be executed. This is the list of basic command that are used

```ruby
visit('page_url') # navigate to page
click_link('id_of_link') # click link by id
click_link('link_text') # click link by link text
click_button('button_name') # click button by button text
fill_in('First Name', :with => 'John') # fill text field
choose('radio_button') # choose radio button
check('checkbox') # check in checkbox 
uncheck('checkbox') # uncheck in checkbox
select('option', :from=>'select_box') # select from dropdown
attach_file('image', 'path_to_image') # upload file
find('.some_class').hover # finds the desired element and simulate mouse hover
```

--

### Advanced `DSL`

For scenarios where basic the DSL cannot help, we use xpath and CSS selectors (CSS selectors will be used by default). This is very common, since modern web applications usually have a lot of JavaScript code that generates HTML elements with attributes that have generated values (like random ids, etc.)

To find a specific element and click on it we can use:

spec/feature/test_spec.rb <!-- .element: class="filename" -->

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

### Capybara provadies special `Matchers` for our `RSpec Expectations`

Capybara has a rich set of options for querying the page for the existence of certain elements, and working with and manipulating those elements.

```ruby
expect(page).to have_selector('table tr')
expect(page).to have_selector(:xpath, './/table/tr')

expect(page).to have_xpath('.//table/tr')
expect(page).to have_css('table tr.foo')
expect(page).to have_content('foo')
```

---

### Debugging

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