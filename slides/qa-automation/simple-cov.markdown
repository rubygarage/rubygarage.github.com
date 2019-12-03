---

layout: slide
title: SimpleCov

---

# SimpleCov

### SimpleCov is a code coverage analysis tool for Ruby.

---

# Installation

--

## Install gem - `simplecov`

Gemfile <!-- .element: class="filename" -->

```ruby
group :test do
  gem 'simplecov', require: false
end
```

Then, run `bundle install` to download and install new gem

```bash
$ bundle install
```

--

Load and launch [SimpleCov](https://github.com/colszowka/simplecov) at the **very top** of your `spec/rails_helper.rb`

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
require 'simplecov'

SimpleCov.start
```

--

## Configuring SimpleCov

If you're making a Rails application, SimpleCov comes with built-in configurations. To use it, the first two lines of your `rails_helper` should be like this:

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
require 'simplecov'

SimpleCov.start 'rails'
```

For example you can add any custom configs like groups and filters:

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
SimpleCov.start 'rails' do
  add_filter '/spec/'         # simple string filter will remove all files that match "/spec/" in their path
  minimum_coverage 95         # define the minimum coverage percentage expected
  minimum_coverage_by_file 90 # define the minimum coverage by file percentage expected
end
```

[Configuration](https://rubydoc.info/gems/simplecov/SimpleCov/Configuration) API documentation to find out what you can customize.

---

# How to use SimpleCov?

--

Just run your tests with RSpec command:

```bash
$ rspec # SimpleCov will generate 'coverage/index.html' file
```

After running your tests, open `coverage/index.html` in the browser of your choice:

For Mac:

```terminal
open coverage/index.html
```

For Ubuntu:

```bash
$ xdg-open coverage/index.html
```
