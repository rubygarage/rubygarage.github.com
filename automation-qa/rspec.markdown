---
layout: slide
title:  RSpec
---

# RSpec

---

## What is RSpec?

RSpec is a unit test framework for the Ruby programming language. RSpec is different than traditional xUnit frameworks like JUnit because RSpec is a Behavior driven development tool. What this means is that, tests written in RSpec focus on the "behavior" of an application being tested. RSpec does not put emphasis on, how the application works but instead on how it behaves, in other words, what the application actually does.

---

<!-- think may be about test types or any else -->

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

```ruby
RSpec.describe 'test' do
  it "lol" do
    expect(2 + 2).to eq(4)
  end
end
```



---


...

---

Control questions

*What is RSpec?*

---

The End

---
