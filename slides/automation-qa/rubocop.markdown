---
layout: slide
title: Rubocop
---

# What is `Rubocop`?

RuboCop is a Ruby static code analyzer and code formatter. Out of the box it will enforce many of the guidelines outlined in the community [Ruby Style Guide](https://rubystyle.guide/).

--

## Install `rubocop`

The first thing we need to do is add our gem to Gemfile

```ruby
gem 'rubocop'
```

Then, run `bundle install` to download and instal new gem

```bash
$ bundle install
```

--

## Configuration

The behavior of RuboCop can be controlled via the `.rubocop.yml` configuration file. It makes it possible to enable/disable certain cops (checks) and to alter their behavior if they accept any parameters. The file can be placed in project directory.

.rubocop.yml <!-- .element: class="filename" -->

```yml
Style/Encoding:
  Enabled: false

Metrics/LineLength:
  Max: 99

Metrics/MethodLength:
  Max: 10
  Exclude:
    - "lib/something.rb"
```

--

## Run it

Running `rubocop` with no arguments will check all Ruby source files in the current directory:

```bash
$ rubocop
```

Alternatively you can pass rubocop a list of files and directories to check:

```bash
$ rubocop app spec lib/something.rb
```

Running RuboCop on it (assuming it's in a file named test.rb) would produce the following report:

```bash
Inspecting 1 file
W

Offenses:

test.rb:1:1: C: Style/FrozenStringLiteralComment: Missing magic comment # frozen_string_literal: true.
def badName
^
test.rb:1:5: C: Naming/MethodName: Use snake_case for method names.
def badName
    ^^^^^^^
test.rb:2:3: C: Style/GuardClause: Use a guard clause instead of wrapping the code inside a conditional expression.
  if something
  ^^

1 file inspected, 3 offenses detected
```
