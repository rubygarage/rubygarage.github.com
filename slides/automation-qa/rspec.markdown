---
layout: slide
title:  RSpec
---

# RSpec

---

## What is RSpec?

RSpec is a unit test framework for the Ruby programming language. Tests written in RSpec focus on the "behavior" of an application being tested. RSpec does not put emphasis on, how the application works but instead on how it behaves, in other words, what the application actually does.

---

# RSpec Test Types

--

![](/assets/images/types-of-test/rails-test-types.png)

- **Unit tests** - these tests individual components in isolation, proving that they implement the expected behavior independent of the surrounding system.

- **Integration tests** - these tests exercise the system as a whole rather than its individual components.

- **Hybrid tests** - these tests what testing several components together but not the full system.

---

# Installation

--

## Make sure that RSpec is not installed.

- Try to find `rspec-rails` inside **Gemfile**

- Find `spec_helper.rb` and `rails_helper.rb` inside **spec** folder at Rails project

If you passed all steps. You can skip Installation step!

--

## Install gem - `rspec-rails`

Gemfile <!-- .element: class="filename" -->

```ruby
group :test do
  gem 'rspec-rails'
end
```

`rspec-rails` is combination of gems:

Gemfile.lock <!-- .element: class="filename" -->

```ruby
rspec-rails (3.9.0)
  actionpack (>= 3.0)
  activesupport (>= 3.0)
  railties (>= 3.0)
  rspec-core (~> 3.9.0)
  rspec-expectations (~> 3.9.0)
  rspec-mocks (~> 3.9.0)
  rspec-support (~> 3.9.0)
```

Based on this, you can add to `Gemfile` this gems and you don't need to install `rspec-rails`


`But not recomended!`

--

To install gems run:

```bash
$ bundle install
```

Generate conventional files for a RSpec project run:

```bash
$ rails generate rspec:install

create  .rspec
create  spec
create  spec/spec_helper.rb
create  spec/rails_helper.rb
```

---

# Clone Repository for Practice

```bash
$ git clone https://github.com/alexyndr/library.git
```

```bash
$ cd library
```

```bash
$ bundle install
```

```bash
$ ruby seed.rb  # will run application
```


---

# Conventional files for a RSpec

--

### What is `spec_helper.rb`?
`spec_helper.rb` - this file describes in the context of RSpec configuration (not Rails)

spec/spec_helper.rb <!-- .element: class="filename" -->

```ruby
RSpec.configure do | config |
  config.expect_with: rspec do | expectations |

    # This option makes the `description` and` failure_message`
    # of custom matchers include text for helper methods defined using `chain`
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with: rspec do | mocks |

    # Prevents you from mocking or stubbing a method that does not exist on a real object.
    mocks.verify_partial_doubles = true
  end

  # Metadata will be inherited by the metadata hash of all host groups and examples.
  config.shared_context_metadata_behavior =: apply_to_host_groups
end
```

--

### What is `rails_helper.rb`?
`rails_helper.rb` - is for specs which do depend on Rails (in a Rails project, most or all of them)

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
  # rspec-expectations config goes here.

  # This line define path for fixtures data
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Run every test method within a transaction
  config.use_transactional_fixtures = true

  # This line automatically added metadata to specs based on their location on the filesystem.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # Runs tests in random order
  config.order = :random

  # Show 10 slowest tests
  config.profile_examples = 10
end
```

---

# First test

spec/unit/first_test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'test' do
  it "first test" do
    expect(2 + 2).to eq(4)
  end
end
```

RSpec naming conventions for files obliges you add `_spec` to end of the file name.

---

## How to run my first spec?

```bash
# Run all spec files
$ rspec
```

```bash
# Run all spec files in a single directory (recursively)
$ rspec spec/unit
```

```bash
# Run a single spec file
$ rspec spec/unit/first_test_spec.rb
```

```bash
# Run a single example from a spec file (by line number)
$ rspec spec/unit/first_test_spec.rb:2
```

--

## Run example spec

spec/unit/first_test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'test' do
  it "first test" do
    expect(2 + 2).to eq(4)
  end

  it "second test" do
    expect(2 + 2).not_to eq(10)
  end
end
```

Test will pase:

```bash
$ rspec spec/unit/first_test_spec.rb

..

Finished in 0.00424 seconds (files took 0.09888 seconds to load)
2 example, 0 failures
```

---

# Output formatters

### Formatters helps visualize output result of tests

--

## Formating

Colorization

```bash
$ rspec spec/unit/first_test_spec.rb --color
```

Progress format (default)

```bash
$ rspec spec/unit/first_test_spec.rb
```

or

```bash
$ rspec spec/unit/first_test_spec.rb  --format progress

....F.....*.....

# '.' represents a passing example, 'F' is failing, and '*' is pending.
```
--

## Documentation format

```bash
$ rspec spec/unit/first_test_spec.rb --format documentation

Array
  #last
    should return the last element
    should not remove the last element
  #pop
    should return the last element
    should remove the last element

Finished in 0.00212 seconds
4 examples, 0 failures
```

--

### What is `.rspec`?

Any code that you have in `.rspec` file, will be required before each test

`Example`:

```ruby
--color

--format documentation

--require rails_helper
```

Now you don't need to require `rails_helper` file to every test.


---

# Structure of RSpec

--

## Specs are usually placed in a canonical directory structure that describes their purpose:

- `Model` specs reside in the `spec/models` directory

- `Controller` specs reside in the `spec/controllers` directory

- `Request` specs reside in the `spec/requests` directory. The directory can also be named integration or api.

- `Feature` specs reside in the `spec/features` directory

---

# Basic syntax of RSpec

--

## Describe

We use the describe() method to define an example group.

```ruby
describe 'A User' do
end
# => A User

describe User do
end
# => User

describe User, 'with no roles assigned' do
end
# => User with no roles assigned
```

--

## Nested groups

```ruby
RSpec.describe User do
  describe 'With no roles assigned' do
    it 'is not allowed to view protected content' do
    end
  end
end

# User
#   with no roles assigned
#     is not allowed to view protected content
```

**Note**: First `describe` in each file_spec should start from `RSpec.describe`

--

## Context

The context() method is an alias for `describe()`.

```ruby
RSpec.describe User
  context 'with no roles assigned' do
    it 'is not allowed to view protected content' do
    end
  end
end

# User
#   with no roles assigned
#     is not allowed to view protected content
```

--

## It

The `it()` method takes a single String, an optional Hash and an optional block. String with `'it'` represents the detail that will be expressed in code within the block.

```ruby
RSpec.describe Array do
  context '#last' do
    it 'returns the last element' do
      array = [:first, :second, :third]
      expect(array.last).to eq(:third)
    end

    it 'does not remove the last element' do
      array = [:first, :second, :third]
      array.last
      expect(array.size).to eq(3)
    end
  end
```

--

## Specify

Alias for `it`. Can be used when decsription can be leaved

```ruby
specify { expect(product).not_to be_featured }
```

---

# `let` and `!let`

--

## `let`

Use let to define a memoized helper method. The value will be cached across multiple calls in the same example but not across examples.

### Use `before`

```ruby
before do
  @empty_array = Array.new
end

it 'is empty' do
  expect(@empty_array).to be_empty
end
```

### Use `let`

```ruby
let(:empty_array) { Array.new }

it 'is empty' do
  expect(empty_array).to be_empty
end
```

--

## `!let`

Use `let`:

```ruby
let(:user) { User.create(data) }

before do
  user
end

it 'is empty' do
  expect(User.count).to eq(1)
end
```

Use `!let`:

```ruby
let!(:user) { User.create(data) }

it 'is empty' do
  expect(User.count).to eq(1)
end
```

`let` is lazy-evaluated: it is not evaluated until the first time the method it defines is invoked. You can use `let!` to force the method’s invocation before each example.

---

# Expectations

Used to define expected outcomes.

--

**RSpec Expectations** lets you express expected outcomes on an object in an example

The basic structure of an rspec expectation is:

```ruby
expect(actual).to     some_matcher(expected)
expect(actual).not_to some_matcher(not_expected)
```

Examples

```ruby
expect(5 + 5).to eq(10)     #=> true
expect(5 + 5).not_to eq(11) #=> true
expect(3 + 2).not_to eq(5)  #=> false
```

--

## Compound Expectations

RSpec allows chaining expectations simply by using **and**. RSpec also offers **or** which means that only one condition needs to be satisfied.

Examples

```ruby
expect("foobazz").to start_with("foo").and end_with("bazz")    #=> true
expect("foofoo").to start_with("foo").and end_with("bazz")     #=> false
expect("green").to eq("green").or eq("yellow").or eq("red")    #=> true
expect("black").to eq("green").or eq("yellow").or eq("red")    #=> false
```

---

# Matchers

--

**RSpec Matchers** provides a number of useful matchers, that we use to define expectations.

Each matcher can be used with `expect(..).to` or `expect(..).not_to` to define positive and negative expectations
respectively on an object. 

Examples

```ruby
expect("a string").to be_an_instance_of(String)     # passes
expect("a string").to be_an_instance_of(Array)      # fail
expect("a string").not_to be_an_instance_of(Array)  # passes
```

--

## `RSpec Matchers` provides a different types of matchers

- Equality/Identity Matchers

- True/False/Nil Matchers

- Class/Type Matchers

- Comparison Matchers

- Predicate matchers

- Other build in matchers

- **all** matcher

- **include** matcher

- **change** matcher

--

## Equality/Identity Matchers

Matchers to test for object or value equality.

| `Matcher` |             `Description`                |            `Example`             |
|    ---    |              -----------                 |           -----------            |
| **eq**    | Passes when actual == expected           | expect(actual).to eq expected    |
| **eql**   | Passes when actual.eql?(expected)        | expect(actual).to eql expected   |
| **be**    | Passes when actual.equal?(expected)      | expect(actual).to be expected    |
| **equal** | Also passes when actual.equal?(expected) | expect(actual).to equal expected |
|           |                                          |                                  |

--

## True/False/Nil Matchers

Matchers for testing whether a value is true, false or nil.

|   `Matcher`   |             `Description`               |          `Example`           |
|      ---      |              -----------                |         -----------          |
| **be true**   | Passes when actual == true              | expect(actual).to be true    |
| **be false**  | Passes when actual == false             | expect(actual).to be false   |
| **be_truthy** | Passes when actual is not false or nil  | expect(actual).to be_truthy  |
| **be_falsey** | Passes when actual is false or nil      | expect(actual).to be_falsey  |
| **be_nil**    | Passes when actual is nil               | expect(actual).to be_nil     |
|               |                                         |                              |

--

## Class/Type Matchers

Matchers for testing the type or class of objects.

|     `Matcher`      |             `Description`               |          `Example`           |
|        ---         |              -----------                |         -----------          |
| **be_instance_of** | Passes when actual is an instance of the expected class                              | expect(actual).to be_instance_of(Expected) |
| **be_kind_of**     | Passes when actual is an instance of the expected class or any of its parent classes | expect(actual).to be_kind_of(Expected)               |
| **respond_to**     | Passes when actual responds to the specified method                                  | expect(actual).to respond_to(expected)               |
|                    |                                         |                              |

--

## Comparison Matchers

Matchers for comparing to values.

|         `Matcher`        |                 `Description`                   |          `Example`           |
|            ---           |                  -----------                    |         -----------          |
| **>**                    | Passes when actual > expected                   | expect(actual).to be > expected    |
| **>=**                   | Passes when actual >= expected                  | expect(actual).to be >= expected   |
| **<**                    | Passes when actual < expected                   | expect(actual).to be < expected    |
| **<=**                   | Passes when actual <= expected                  | expect(actual).to be <= expected   |
| **be_between inclusive** | Passes when actual is <= min and >= max         | expect(actual).to be_between(min, max).inclusive |
| **be_between exclusive** | Passes when actual is < min and > max           | expect(actual).to be_between(min, max).exclusive |
| **match**                | Passes when actual matches a regular expression | expect(actual).to match(/regex/)                 |
| **start_with**           | Passes when actual start with expected   | expect(actual).to start_with expected |
| **end_with**             | Passes when actual end with expected   | expect(actual).to end_with expected |
|                          |                                                 |                              |

--

## Predicate matchers

For any [predicate method](http://ruby-for-beginners.rubymonstas.org/objects/predicates.html), RSpec gives you a corresponding matcher. Simply prefix the method with `be_` or `have_`.

|   `Matcher`          |             `Description`     |          `Example`                   |
|      ---             |              -----------      |         -----------                  |
| **be_zero**          | calls 7.zero?                 | expect(7).not_to be_zero             |
| **be_empty**         | calls [].empty?               | expect([]).to be_empty               |
| **be_multiple_of()** | calls x.multiple_of?(3)       | expect(x).to be_multiple_of(3)       |
| **have_key()**       | calls hash.has_key?(:foo)     | expect(hash).to have_key(:foo)       |
| **have_odd_values**  | calls array.has_odd_values?   | expect(array).not_to have_odd_values |
|                      |                               |                                      |

--

## `all` matcher

Use the **all** matcher to specify that a collection's objects all pass an expected matcher. This works on any enumerable object.

|   `Matcher`     |             `Description`     |          `Example`                   |
|      ---        |              -----------      |         -----------                  |
| **all**         | Passes when all elements satisfy the conditions | expect([1, 3, 5]).to all( be < 10 ) |
|                 |                               |                                      |

--

## `include` matcher

Use the **include** matcher to specify that a collection includes one or more expected objects.

|   `Matcher`     |             `Description`     |          `Example`                  |
|      ---        |              -----------      |         -----------                 |
| **include**     | Passes when actual includes expected | expect([1, 2]).to include(1)|
|                 |                               |                                     |

--

## `change` matcher

The **change** matcher is used to specify that a block of code changes some mutable state.

|   `Matcher`     |             `Description`     |          `Example`                  |
|      ---        |              -----------      |         -----------                 |
| **change**      | Passes when actual change to expected | expect { arr.push(4) }.to change { arr.length }.from(3).to(4) |
|                 |                               |                                     |

---

# Stub

--

### Stub is an object that holds predefined data and uses it to answer calls during tests.

It is used when we cannot or don’t want to involve objects that would answer with real data or have undesirable side effects.

```ruby
obj = double() # create a dummy

# tells the 'obj' to return the value ':value' when it receives the roll ':method_name'
allow(obj).to receive(:method_name).and_return(:value)
```

Same stub but with `Lazy evaluation`:

```ruby
allow(obj).to receive(:method_name) { :value }
```

--

spec/unit/first_test_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe 'test' do
  it 'return stub count of user friends' do
    user = double   # create a dummy, because we don't have real User class

    allow(user).to receive(:friends_count).and_return(11)

    expect(user.friends_count).to eq(11)
  end
end
```

```
Stub test
  return stub count of user friends

Finished in 0.01035 seconds (files took 1.78 seconds to load)
1 example, 0 failures

```

---

# Hooks

RSpec provides `before`, `after` and `around` hooks.

This methods available from any **describe** or **context** block.

The most common hooks used in RSpec are `before` and `after` hooks. They provide a way to define and run the setup and teardown code.

--

### Hooks types

- **after**

  ```ruby
  after(*args, &block)
  ```

  Declare a block of code to be run after each example (using `:example`) or once after all examples in the context (using `:context`).

- **around**

  ```ruby
  around(*args) {|Example| ... }
  ```

  Declare a block of code, parts of which will be run before and parts after the example.

- **before**

  ```ruby
  before(*args, &block)
  ```

  Declare a block of code to be run before each example (using `:example`) or once before any example (using `:context`).

  **`Note`**: The `:example` and `:context` scopes are also available as `:each` and `:all`, respectively. Use whichever you prefer.

--

### Here is a simple example that illustrates when each hook is called.

```ruby
describe "Before and after hooks" do
   before(:each) do
      puts "Runs before each Example"
   end
   after(:each) do
      puts "Runs after each Example"
   end
   before(:all) do
      puts "Runs before all Examples"
   end
   after(:all) do
      puts "Runs after all Examples"
   end

   it 'is the first Example in this spec file' do
      puts 'Running the first Example'
   end

   it 'is the second Example in this spec file' do
      puts 'Running the second Example'
   end
end
```

```
Runs before all Examples
Runs before each Example
Running the first Example
Runs after each Example
.Runs before each Example
Running the second Example
.Runs after each Example
Runs after all Examples
```

---

# Pending

```ruby
RSpec.describe Array do
  skip 'not implemented yet' do
  end

  context '#last' do
    it 'returns the last element', skip: true do
      array = [:first, :second, :third]
      expect(array.last).to eq(:third)
    end

    it 'does not remove the last element', skip: 'reason explanation' do
      array = [:first, :second, :third]
      array.last
      expect(array.size).to eq(3)
    end
  end

  it 'does something else' do
    skip # or skip 'reason explanation'
  end
end
```

--

```bash
Array
  not implemented yet (PENDING: No reason given)
  does something else (PENDING: No reason given)
  #last
    returns the last element (PENDING: No reason given)
    does not remove the last element (PENDING: reason explanation)

Pending: (Failures listed here are expected and do not affect your suites status)

  1) Array not implemented yet
     # No reason given
     # ./spec/a_spec.rb:2

  2) Array does something else
     # No reason given
     # ./spec/a_spec.rb:18

  3) Array#last returns the last element
     # No reason given
     # ./spec/a_spec.rb:6

  4) Array#last does not remove the last element
     # reason explanation
     # ./spec/a_spec.rb:11


Finished in 0.00105 seconds (files took 0.08152 seconds to load)
4 examples, 0 failures, 4 pending
```

--

## Temporarily pending by changing `it` to `xit`

```ruby
RSpec.describe Array do

  describe "an example" do
    xit "is pending using xit" do
      true.should be(true)
    end
  end

end
```

```bash
Pending:
  an example is pending using xit

Finished in 0.00105 seconds (files took 0.08152 seconds to load)
1 examples, 0 failures, 1 pending
```

---

# RSpec best practices

Best practice include ideas how to improve your specs quality and increase efficiency of your BDD/TDD workflow.

- Every file name, that testing the code should to end with `_spec.rb`

- Do not litter the files `rails_helper.rb`, `spec_helper.rb`

- Move all configs to `spec/support/`

- Add `--require spec_helper` to file `.rspec` and you don't need to require this file in every spec file

- Structure folders `spec/features/controller_name/action_name` like `spec/features/users/create`

--

## Use contexts

`context` starts either with `"with"` or `"when"`, such "when status is pending"

```ruby
# Bad
it 'has 200 status code if logged in' do
  expect(response).to respond_with 200
end
it 'has 401 status code if not logged in' do
  expect(response).to respond_with 401
end
```

```ruby
# good
context 'when logged in' do
  it { is_expected.to respond_with 200 }
end
context 'when logged out' do
  it { is_expected.to respond_with 401 }
end
```

--

## Keep your description short

A spec description should never be longer than 40 characters. If this happens you should split it using a context.

```ruby
it 'has 422 status code if an unexpected params will be added' do
```

```ruby
context 'when not valid' do
  it { is_expected.to respond_with 422 }
end
```

For more practices go
[here](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)

---

# Additional tools

--

## Shared examples

Shared examples let you describe behavior of types or modules. When declared, a shared group’s content is stored. It is only realized in the context of another example group, which provides any context the shared group needs to run.

- `include_examples` 'name' # include the examples in the current context

- `it_behaves_like` 'name' # include the examples in a nested context

- `it_should_behave_like` 'name' # include the examples in a nested context

--

You can use any of these methods to use shared examples. File with share examples should be loaded before the files that use them

```ruby
RSpec.describe 'test' do
  shared_example 'a collection object' do
    expect(collection.to_a).to eq([1])
  end

  describe '<<' do
    let(:collection) { Array.new }

    it 'adds objects to the end of the collection' do
      collection << 1
      it_behaves_like 'a collection object'
    end
  end
end
```

--

or

```ruby
require 'set'

RSpec.shared_examples 'a collection object' do
  describe '<<' do
    it 'adds objects to the end of the collection' do
      collection << 1
      collection << 2
      expect(collection.to_a).to eq([1,2])
    end
  end
end

RSpec.describe Array do
  it_behaves_like 'a collection object' do
    let(:collection) { Array.new }
  end
end

RSpec.describe Set do
  it_behaves_like 'a collection object' do
    let(:collection) { Set.new }
  end
end
```

--

## Shared context

Use shared_context to define a block that will be evaluated in the context of example groups either explicitly, using include_context, or implicitly by matching metadata.

```ruby
RSpec.shared_context 'shared stuff', a: :b do
  before { @some_var = :some_value }

  def shared_method
    'it works'
  end

  let(:shared_let) { {'arbitrary' => 'object'} }

  subject do
    'this is the subject'
  end
end
```

--

## Include context

```ruby
RSpec.describe "group that includes a shared context using 'include_context'" do
  include_context 'shared stuff'

  it 'has access to methods defined in shared context' do
    expect(shared_method).to eq('it works')
  end

  it 'has access to methods defined with let in shared context' do
    expect(shared_let['arbitrary']).to eq('object')
  end

  it 'runs the before hooks defined in the shared context' do
    expect(@some_var).to eq(:some_value)
  end

  it 'accesses the subject defined in the shared context' do
    expect(subject).to eq('this is the subject')
  end
end
```

--

## metadata

```ruby
RSpec.describe 'group that includes a shared context using metadata', a: :b do
  it 'has access to methods defined in shared context' do
    expect(shared_method).to eq('it works')
  end

  it 'has access to methods defined with let in shared context' do
    expect(shared_let['arbitrary']).to eq('object')
  end

  it 'runs the before hooks defined in the shared context' do
    expect(@some_var).to eq(:some_value)
  end

  it 'accesses the subject defined in the shared context' do
    expect(subject).to eq('this is the subject')
  end
end
```

```bash
$ rspec spec/shared_stuff_spec.rb

........
Finished in 0.00758 seconds
8 examples, 0 failures
```

--

# Filters

```ruby
describe Actor do
  let(:name) { 'Ivan' }

  context 'with subject redefinition', :focus do # or focus: true
    let(:actor) {  Actor.new(name) }
    subject { actor }

    it 'has name', :slow do # or slow: true
      expect(subject.name).to eq(name)
    end
  end
end
```

```bash
$ rspec spec/subject_spec.rb --tag focus --format documentation

Actor
  with subject redefinition
    has name

Finished in 1.22 seconds
1 example, 0 failures
```

--

before, after, and around hooks defined in the block passed to
RSpec.configure can be constrained to specific examples and/or groups using
metadata as a filter.

rails_helper.rb <!-- .element: class="filename" -->


```ruby
RSpec.configure do |c|
  c.before(:each, type: :model) do
    # do some
  end
end
```

`before` will be works when run tests with current `type`

```ruby
describe "something", type: :model do
end
```

--

### You can also include helpers for tests that you need

```ruby
RSpec.configure do |config|
  config.include ModelHelper, type: :model
  config.include FeatureHelper, type: :feature
  config.include TestHelper, type: :test_name
  config.include ControllerHelper, type: :controller
end
```

```ruby
# first spec file
describe "something", type: :model do
  # will be included ModelHelper
end

# second spec file
describe "something", type: :feature do
  # will be included FeatureHelper
end
```

--

### If your tests are time dependent you can use travel_to
Add the following to the `spec_helper.rb` file

```ruby
RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
end
```

Then in the test you can use

```ruby
before(:all) do
  ENV['TZ'] = 'UTC'
  travel_to Time.zone.local(2021, 03, 18, 12, 00, 00)
end
```

For more practices go
[here](http://lucasnogueira.me/en/How-to-time-travel-safely-but-only-on-your-tests)

--

### If you need to find a specific row in a table or something similar
You can create a method on the page object like the example below

```ruby
def get_needed_data_with_index(index)
  within(:xpath, "//table/tbody/tr[#{index}]") do
    block_given? ? yield : raise('data not provided')
  end
end
```

Where `index` it's needed line in the table. `xpath` needs to be changed according to your DOM

--

### If you need to sort list of elements
```ruby
it 'sorts by ...' do
  expect(page.element_ids.map(&:text)).to eq([element3, element2, element1].map(&:id).map(&:to_s))

  page.sort_list_by(name: 'Name')

  expect(page.element_ids.map(&:text)).to eq([element1, element2, element3].map(&:id).map(&:to_s))
end
```
`element_ids` this is elements in your page object
```ruby
elements :element_ids, 'some css'
```

--

---

# The End
