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

Define `simplecov` file, which manages the [SimpleCov](https://github.com/colszowka/simplecov) configuration:

spec/support/simplecov.rb <!-- .element: class="filename" -->

```ruby
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'         # simple string filter will remove all files that match "/spec/" in their path
  minimum_coverage 95         # define the minimum coverage percentage expected
  minimum_coverage_by_file 90 # define the minimum coverage by file percentage expected
end
```

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
