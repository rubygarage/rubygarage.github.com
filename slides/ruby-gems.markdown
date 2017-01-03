---
layout: slide
title:  Ruby Gems
---

# Gem

<br>

[Go to Table of Contents](/)

---

# Gem

A gem is a packaged Ruby application or library. It has a name and a version.

## RubyGems

RubyGems is the name of the project that developed the gem packaging system and the *gem* command. You can get RubyGems
from the main http://rubygems.org repository. RubyGems is now part of the standard library from Ruby version 1.9.

## Command `gem`

The `gem` command is used to build, upload, download, and install Gem packages.

---

# Usage

## Installation

```bash
$ gem install progressbar
```

## Using a gem in your code

```ruby
require 'progressbar'

bar = ProgressBar.new('Example progress', 50)
total = 0

until total >= 50
  sleep(rand(2)/2.0)
  increment = (rand(6) + 3)
  bar.inc(increment)
  total += increment
end
```

## Uninstallation

```bash
$ gem uninstall progressbar
```

---

# Bundler

Bundler keeps ruby applications running the same code on every machine. It does this by managing the gems that the
application depends on. Given a list of gems, it can automatically download and install those gems, as well as any
other gems needed by the gems that are listed. Before installing gems, it checks the versions of every gem to make sure
that they are compatible, and can all be loaded at the same time. After the gems have been installed, Bundler can help
you update some or all of them when new versions become available. Finally, it records the exact versions that have
been installed, so that others can install the exact same gems.

## Bundler installation

```bash
$ gem install bundler
```

## Bundle init

```bash
$ bundle init
Writing new Gemfile to /Users/sparrow/Www/test-bundler/Gemfile
```

---

# Gemfile

Gemfile <!-- .element class="filename" -->

```ruby
source 'http://rubygems.org'
# Gemfiles require at least one gem source

gem 'nokogiri'
gem 'rack', '~>1.1'
# => "~>1.1" is identical to ">=1.1" and " "spec"
# => If a gem main file is different than the gem name, specify how to require it

gem "sinatra", :git => "git://github.com/sinatra/sinatra.git"
# => Git repositories are also valid gem sources
```

Bundle install

```bash
$ bundle install
```

Bundle update

```bash
$ bundle update
```

---

# Gemfile.lock

```ruby
GIT
  remote: git://github.com/sinatra/sinatra.git
  revision: 9984d0d2b3f1ea12273c6c25f8e102b2329f33e9
  specs:
    sinatra (1.4.0)
      rack (~> 1.4)
      rack-protection (~> 1.3)
      tilt (~> 1.3, >= 1.3.3)
GEM
  remote: http://rubygems.org/
  specs:
    diff-lcs (1.1.3)
    nokogiri (1.5.6)
    rack (1.4.3)
    rack-protection (1.3.2)
      rack
    rspec (2.12.0)
      rspec-core (~> 2.12.0)
      rspec-expectations (~> 2.12.0)
      rspec-mocks (~> 2.12.0)
    rspec-core (2.12.2)
    rspec-expectations (2.12.1)
      diff-lcs (~> 1.1.3)
    rspec-mocks (2.12.1)
    tilt (1.3.3)
PLATFORMS
  ruby
DEPENDENCIES
  nokogiri
  rack (~> 1.1)
  rspec
  sinatra!
```

---

# Creating gem

Preparing environment

```bash
$ rvm use 1.9.3-head@create-gem --create
Using /Users/sparrow/.rvm/gems/ruby-1.9.3-head with gemset create-gem
```

Installing bundler

```bash
$ gem install bundler
```

Creating gem with bundler

```bash
$ bundle gem new_gem
create  new_gem/Gemfile
create  new_gem/Rakefile
create  new_gem/LICENSE
create  new_gem/README.md
create  new_gem/.gitignore
create  new_gem/new_gem.gemspec
create  new_gem/lib/new_gem.rb
create  new_gem/lib/new_gem/version.rb
Initializating git repo in /Users/sparrow/Www/new_gem
```

---

# Gem structure

```text
new_gem/
|-- lib/
|   |-- new_gem/
|   |   |-- version.rb
|   |-- new_gem.rb
|-- .gitignore
|-- Gemfile
|-- LICENSE
|-- new_gem.gemspec
|-- Rakefile
|-- README.md
```

---

# Gemspec

new_gem.gemspec <!-- .element class="filename" -->

```ruby
require File.expand_path('../lib/new_gem/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Vladimir Vorobyov']
  gem.email         = ['sparrowpublic@gmail.com']
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ''
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'new_gem'
  gem.require_paths = ['lib']
  gem.version       = NewGem::VERSION
end
```

---

# Gem structure

lib/new_gem/version.rb <!-- .element class="filename" -->

```ruby
module NewGem
  VERSION = "0.0.1"
end
```

Gemfile <!-- .element class="filename" -->

```ruby
source 'https://rubygems.org'
# Specify your gem dependencies in new_gem.gemspec
gemspec
```

new_gem.gemspec <!-- .element class="filename" -->

```ruby
# ...
Gem::Specification.new do |gem|
  # ...
  gem.add_dependency 'sqlite3'
  gem.add_development_dependency 'rspec'
end
```

---

# Gem structure

lib/new_gem.rb <!-- .element class="filename" -->

```ruby
require 'new_gem/version'

module NewGem
  # Your code goes here...
end
```

Rakefile <!-- .element class="filename" -->

```ruby
#!/usr/bin/env rake
require 'bundler/gem_tasks'
```

---

# Testing

Add rspec to `new_gem.gemspec`

new_gem.gemspec <!-- .element class="filename" -->

```ruby
# ...
Gem::Specification.new do |gem|
  # ...
  gem.add_development_dependency 'rspec'
end
```

spec/spec_helper.rb <!-- .element class="filename" -->

```ruby
require 'bundler/setup'
require 'new_gem'
```

spec/new_gem_spec.rb <!-- .element class="filename" -->

```ruby
require 'spec_helper'

describe NewGem do
  context '#name' do
    it 'should return gem name' do
      NewGem.name.should == 'New Gem'
    end
  end
end
```

---

# Testing

lib/new_gem.rb <!-- .element class="filename" -->

```ruby
require 'new_gem/version'

module NewGem
  def self.name
    'New Gem'
  end
end
```

## Running tests

```bash
$ rspec spec/
.
Finished in 0.00051 seconds
1 example, 0 failures
```

---

# Build and push gem to RubyGems.org

Rakefile <!-- .element class="filename" -->

```ruby
#!/usr/bin/env rake
require 'bundler/gem_tasks'
```

Rake tasks

```ruby
rake build    # Build new_gem into the pkg directory
rake install  # Build and install new_gem into system gems
rake release  # Create version tag and build and push new_gem to Rubygems
```

Build gem

```bash
$ rake build
new_gem 0.0.1 built to pkg/new_gem-0.0.1.gem
```

---

# The End

<br>

[Go to Table of Contents](/)
