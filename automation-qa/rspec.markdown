---
layout: slide
title:  RSpec
---

# RSpec

---

## What is RSpec?

RSpec is a unit test framework for the Ruby programming language. RSpec is different than traditional xUnit frameworks like JUnit because RSpec is a Behavior driven development tool. What this means is that, tests written in RSpec focus on the "behavior" of an application being tested. RSpec does not put emphasis on, how the application works but instead on how it behaves, in other words, what the application actually does.

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

Based on this, you can add to `Gemfile` this gems and you needn't to install `rspec-rails`


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

# Conventional files for a RSpec

--


### What is `spec_helper.rb`?
`spec_helper.rb` - every spec file needs to require this config(it gives your tests functionality)

spec/spec_helper.rb <!-- .element: class="filename" -->

```ruby
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option makes the `description` and `failure_message`
    # of custom matchers include text for helper methods defined using `chain`
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a real object.
    mocks.verify_partial_doubles = true
  end

  # Metadata will be inherited by the metadata hash of all host groups and examples.
  config.shared_context_metadata_behavior = :apply_to_host_groups
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
end
```

--

### What is `.rspec`?

Any code that you have in `.rspec` file, will be required before each test

`Example`:

```ruby
--require rails_helper
```

Now you don't need to requre `rails_helper` file to every test.

---

# First test



spec/first_test_spec.rb <!-- .element: class="filename" -->

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

---

## How to run my first spec?

```bash
# Run all spec files
$ rspec
```

```bash
# Run all spec files in a single directory (recursively)
$ rspec spec/features
```

```bash
# Run a single spec file
$ rspec spec/controllers/accounts_controller_spec.rb
```

```bash
# Run a single example from a spec file (by line number)
$ rspec spec/controllers/accounts_controller_spec.rb:8
```

--

## Run example spec

spec/first_test_spec.rb <!-- .element: class="filename" -->

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
$ rspec spec/first_test_spec.rb

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
$ rspec spec/arrays/push_spec.rb --color
```

Progress format (default)

```bash
$ rspec spec/arrays/push_spec.rb
```

or

```bash
$ rspec spec/arrays/push_spec.rb  --format progress

....F.....*.....

# '.' represents a passing example, 'F' is failing, and '*' is pending.
```
--

## Documentation format

```bash
$ rspec spec/arrays/push_spec.rb --format documentation

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

---

# Structure of RSpec

--

## Specs are usually placed in a canonical directory structure that describes their purpose:

- `Model` specs reside in the `spec/models` directory

- `Controller` specs reside in the `spec/controllers` directory

- `Request` specs reside in the `spec/requests` directory. The directory can also be named integration or api.

- `Feature` specs reside in the `spec/features` directory

- `View` specs reside in the `spec/views` directory

- `Helper` specs reside in the `spec/helpers` directory

- `Mailer` specs reside in the `spec/mailers` directory

- `Routing` specs reside in the `spec/routing` directory

- `Job` specs reside in the `spec/jobs` directory

- `System` specs reside in the `spec/system` directory

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

## `let` and `!let`

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

The basic structure of an rspec expectation is:

```ruby
expect(actual).to matcher(expected)
expect(actual).not_to matcher(expected)
```

Examples

```ruby
expect(5+5).to eq(10) #=> true
expect(5 + 5).not_to eq(11) #=> true
```

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

---

# Shared examples

--

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

---

# Hooks

...


---

# RSpec best practices

--


---

# Control questions

*What is RSpec?*
...

---

# The End
