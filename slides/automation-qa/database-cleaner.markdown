---

layout: slide
title: Database Cleaner

---

# Database cleaning

--

**Data cleaning** - is the process of preparing data for analysis by removing or modifying data that is incorrect, incomplete, irrelevant, duplicated, or improperly formatted. This data is usually not necessary or helpful when it comes to analyzing data because it may hinder the process or provide inaccurate results. 

---

# Setup Database cleaning

---

## If you are using Rails earlier than 5.1.5

--

Earlier versions of Rails 5.1 had a defect in ActionDispatch::SystemTesting::Server that caused problems with rolling back the `transaction`. So in this case we will be use `database_cleaner` gem. 

--

The first thing we need to do is add our gem to Gemfile in `:test` group

```ruby
group :test do
  gem "database_cleaner"
  gem "selenium-webdriver" # From box only in Rails later than 5.1
end
```

Then, run `bundle install` to download and install new gem

```bash
$ bundle install
```

Change `use_transactional_fixtures = false` this will disable rspec-rails’ implicit wrapping of tests in a
database transaction. 	

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
config.use_transactional_fixtures = false
```

--

Define `database_cleaner` file, which manages the [Database cleaner](https://github.com/DatabaseCleaner/database_cleaner) configuration:

spec/support/database_cleaner.rb <!-- .element: class="filename" -->

```ruby
RSpec.configure do |config|
  config.before(:suite) do
    # Before the entire test suite runs, clear the test database out completely
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    # Sets the default database cleanjing strategy to be transactions
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, :js => true) do
    # Chooses the “truncation” strategy if your Capybara use js driver
    DatabaseCleaner.strategy = :truncation
  end
  # Next lines hook up database_cleaner around the beginning and end of each test
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

---

## If you are using Rails later than 5.1.5

--

The main idea `Database cleaning` is to start each example with a clean database, create whatever data
is necessary for that example, and then remove that data by simply rolling back
the `transaction` at the end of the example.

--

Make sure that `use_transactional_fixtures = true` it will run every example within a transaction

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
config.use_transactional_fixtures = true
```

Define `basic_configure` file, which manages the Capybara driver configuration:

spec/support/basic_configure.rb <!-- .element: class="filename" -->

```ruby
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
```

`driven_by` - is Rails method which manages the Capybara driver configuration. The argument to driven_by is the Capybara driver.

`:type` - is rspec-rails method which define directory structure (system, feature, model, controller, [etc](https://relishapp.com/rspec/rspec-rails/v/3-9/docs/directory-structure).)

`:system` - is system specs are RSpec's wrapper around Rails' own [system tests](https://relishapp.com/rspec/rspec-rails/docs/system-specs/system-spec)

--

### Data created in before(:each) are **rolled back**

Any data you create in a `before(:each)` hook will be rolled back at the end of
the example. This is a good thing because it means that each example is
isolated from state that would otherwise be left around by the examples that
already ran. For example:

```ruby
describe Widget do
  before(:each) do
    @widget = Widget.create
  end
  it "does something" do
    expect(@widget).to do_something
  end
  it "does something else" do
    expect(@widget).to do_something_else
  end
end
```

The `@widget` is recreated in each of the two examples above, so each example
has a different object, and the underlying data is rolled back so the data
backing the `@widget` in each example is new.

`Note` Data created in before(`:all`) are **not rolled back**
