---
layout: slide
title:  Install Rspec
---

# Adding specs to the project

<img src="/assets/images/install-rspec/rspec.png"  width="240" height="240">

---

## Gem `rspec-rails`

`rspec-rails` brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework, Minitest.

--

## Install `rspec-rails`

The first thing we need to do is add our gem to Gemfile in `:test` group

```ruby
group :test do
  gem "rspec-rails"
end
```

Run `bundle install` to download and instal new gem

```bash
$ bundle install
```

```bash
$ rails generate rspec:install
```

Previous command will create for us next files:

```bash
create  .rspec
create  spec
create  spec/spec_helper.rb
create  spec/rails_helper.rb
```

---

### What is `spec_helper.rb`?
`spec_helper.rb` - is for specs which don't depend on Rails (such as specs for classes in the lib directory).

--

spec/spec_helper.rb <!-- .element: class="filename" -->

```ruby
RSpec.configure do |config|
  # rspec-expectations config goes here.

  config.expect_with :rspec do |expectations|
    # This option makes the `description` and `failure_message`
    # of custom matchers include text for helper methods defined using `chain`
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object.
    mocks.verify_partial_doubles = true
  end

  # Metadata will be inherited by the metadata hash of all host groups and examples.
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
```

---

### What is `rails_helper.rb`?
`rails_helper.rb` - is for specs which do depend on Rails (in a Rails project, most or all of them). rails_helper.rb requires spec_helper.rb

--

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
# This line will load /spec/spec_helper.rb
require 'spec_helper'

# Set default environment to `test` for Rspec
ENV['RAILS_ENV'] ||= 'test'

# Returns absolute path of the file environment.rb, which is located in the 'config' directory.
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# This line will load rspec-rails
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # This line define path for fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Run every test method within a transaction
  config.use_transactional_fixtures = true

  # This line automatically added metadata to specs based on
  # their location on the filesystem.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end
```

---

## RSpec best practice

Best practice include ideas how to improve your specs quality and increase efficiency of your BDD/TDD workflow.

*Every file name, that testing the code should to end with `_spec.rb`*

*Do not litter the files `rails_helper.rb`, `rspec_helper.rb`. Move all configs to `./spec/support/`*

--

### Stop writing `require 'rails_helper'` in every spec
Simply add this to your `.rspec` instead:

.rspec <!-- .element: class="filename" -->

```ruby
require rails_helper
```

---

## RSpec give us some new methods, lets look

- `describe` - The describe method creates an example group. Within the block passed to
describe you can declare nested groups using the describe method. Use describe to separate methods being tested or behavior being tested.

- `context` - alias `describe`, but you can use it if you want to separate specs based on conditions.

- `it` - create a test block with RSpec, where we write our expectation.

- `specify` - alias `it`, but you can use it to make your tests more readable.

- `subject` makes way clearer about what you're actually testing and helps you stay DRY in your tests.

--

## Describe your methods

Keep clear the methods you are describing using "." as prefix for class methods and "#" as prefix for instance methods.

```ruby
### Bad
describe 'the authenticate method for User' do
describe 'if the user is an admin' do
```

```ruby
### Good
describe '.authenticate' do
describe '#admin?' do
```

--

### Use context

`context` starts either with `"with"` or `"when"`, such "when status is pending"

```ruby
### wrong
describe User do
  it "should save when name is not empty" do
    User.new(:name => 'Alex').save.should == true
  end

  it "should not save when name is empty" do
    User.new.save.should == false
  end
end
```

```ruby
### good
describe User do
  let (:user) { User.new }

  context "when name is empty" do
    it "should not be valid" do
      expect(user.valid?).to be_false
    end

    it "should not save" do
      expect(user.save).to be_false
    end
  end
end
```

--

## `it`
`it` describes a test case (one expectation) and specify only one behavior. Multiple expectations in the same example are signal that you may be specifying multiple behaviors. By specify only have one expectation, helps you on finding possible errors, going directly to the failing test, and to make your code readable.

```ruby
it { expect(page).to have_current_path root_path }
```

or

```ruby
it 'stay on main page' do
  expect(page).to have_current_path root_path
end
```

`specify` alias for `it`

```ruby
  specify { expect(page).to have_current_path root_path }
```

--

## `subject`

- It's instantiated lazily. That is, the implicit instantiation of the described class or the execution of the block passed to `subject` doesn't happen until `subject` or the named `subject` is referred to in an example. If you want your explicit subject to be instantiated eagerly (before an example in its group runs), say `subject!` instead of `subject`

- Expectations can be set on it implicitly (without writing subject or the name of a named subject):

```ruby
describe A do
  it { is_expected.to be_an(A) }
end
```

---

# Mocks vs Stubs

### What is the difference?

- A stub is only a method with a canned response, it doesn’t care about behavior.

- A mock expects methods to be called, if they are not called the test will fail.

--

### `Stubbing`

Stub is an object that holds predefined data and uses it to answer calls during tests. It is used when we cannot or don’t want to involve objects that would answer with real data or have undesirable side effects.

```ruby
# create a double
obj = double()
```

Method Stubs

A method stub is an instruction to an object (real or test double) to return a
known value in response to a message:

```ruby
# tells the die object to return the value 3 when it receives the roll message
allow(die).to receive(:roll) { 3 }

# stub a method
obj.stub(:message) # returns obj

# specify a return value
obj.stub(:message) { 'this is the value to return' }
```

--

### `Mocking`

`mocking` is interesting and usually we're doing mocking when the scenario which we want to test require another service.

You may mock just everything so your spec will never hit the database or another service. But, this is something wrong. When your model code changed or the initiliaze method of service you are call changed, your code will break without get failing specs before merge to production.

```ruby
expect(mock).to receive(:flip).with("ruby.jpg") # mock will return nil

expect(mock).to receive(:flip).with("ruby.jpg").and_return("ruby-flipped.jpg") # mock will return a result
```

---

### What is `expectation`?

`rspec-expectations` - is used to define expected outcomes.

The basic structure of an rspec expectation is:

```ruby
expect(actual).to matcher(expected)
expect(actual).not_to matcher(expected)
```

Examples

```ruby
expect(5).to eq(5)
expect(5).not_to eq(4)
```

---

### What is `matcher`?

A matcher is any object that responds to the following methods:

```ruby
matches?(actual)
failure_message
```
Types od matchers:

- `Eq matchers`

- `Equal matchers`

- `Comparisons matchers`

- `Between matchers`

- `Types/classes/response`

- `Start/End`

- `Exist matchers`

- `True/False matchers`

- `Custom matchers`

- `...`


About of different type matchers you can read [here](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)

--

### Eq matcher

```ruby
expect(obj).to eq(expected)
expect(obj).not_to eq(expected)
```

Passes if given and expected are of equal value, but not necessarily the same object.
```ruby
RSpec.describe 'a string' do
  context '#eq' do
    it 'is equal to another string of the same value' do
      expect('this string').to eq('this string')
    end
  end
end
```

--

### Equal matcher

```ruby
expect(obj).to equal(expected)
expect(obj).not_to equal(expected)
```

Passes if given and expected are the same object (object identity).
```ruby
RSpec.describe 'a string' do
  context '#equal' do
    it 'is equal to itself' do
      string = 'this string'
      expect(string).to equal(string)
    end
  end
end
```

Note: expect syntax doesn't support '==' matcher

--

## Comparisons matchers

```ruby
expect(obj).to be >  expected
expect(obj).to be >= expected
expect(obj).to be
```

### Between matchers

```ruby
expect(obj).to be_between(minimum, maximum).inclusive
expect(obj).to be_between(minimum, maximum).exclusive
```

```ruby
expect(10).to be_between(1, 10).inclusive
expect(10).to be_between(1, 11).exclusive
```

### Start/End matchers

```ruby
expect(obj).to start_with expected
expect(obj).to end_with expected
```

```ruby
expect('first string').to start_with('first')
expect('first string').not_to start_with('second')
expect([1,3,5]).to start_with(1,3)
```

--

### Types and responses

```ruby
expect(obj).to respond_to(expected)
expect(obj).to be_instance_of(expected)
expect(obj).to be_kind_of(expected)
```

--

### Include matchers

Passes if given includes expected. This works for collections and Strings. You can also pass in multiple args and it
will only pass if all args are found in collection.

```ruby
expect([1,2,3]).to include(3)
expect([1,2,3]).to include(2,3)
expect('spread').to include('read')
expect('spread').to_not include('red')
```

--

### Exist matchers

```ruby
expect(obj).to exist
expect(obj).not_to exist
expect(obj).to exist(*args)
expect(obj).not_to exist(*args)
```

Passes if given.exist? or given.exists?

--

### True/False matchers

```ruby
expect(obj).to be_truthy    # passes if obj is truthy (not nil or false)
expect(obj).to be true      # passes if obj == true
expect(obj).to be_falsey    # passes if obj is falsy (nil or false)
expect(obj).to be false     # passes if obj == false
expect(obj).to be_nil  
end
```

--

### Custom matchers

Rspec has many useful matchers, we already used be true, be false, and so on. Sometimes, when expecting given values, we repeat the same code over and over again.

```ruby
RSpec.feature 'some feature', type: :feature do
  it 'saves data' do
    #..

    expect(page).to have_css('.c-alert--success', text: 'Saved successfully', visible: :all)
  end

  it 'returns errors' do
    #..

    expect(page).to have_css('.c-alert--failed', text: 'Failed to save', visible: :all)
  end
end
```

wouldn’t be easier if you could write just this

```ruby
expect(page).to have_flash_message("Saved successfully", type: :success)
```

---

### Creating spec file

Lets create feature spec file

```bash
$ rails g rspec:feature mainpage
```

Previous command will create for us new file:

spec/features/mainpage_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.feature "Mainpages", type: :feature do
  pending "add some scenarios (or delete) #{__FILE__}"
end
```

---

### How to run my first spec?

For running specs you can choose one of several commands:

```bash
# Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)
$ bundle exec rspec
```

```bash
# Run all spec files in a single directory (recursively)
$ bundle exec rspec spec/features
```

```bash
# Run a single spec file
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb
```

```bash
# Run a single example from a spec file (by line number)
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb:8
```

```bash
# See all options for running specs
$ bundle exec rspec --help
```
