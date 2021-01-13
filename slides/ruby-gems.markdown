---
layout: slide
title:  Ruby Gems
---

# Ruby Gems

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
source 'http://rubygems.org' # Gemfile requires at least one gem source

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# These gems are in the :default group
gem 'rack', '~> 2.0.1'
gem 'my_gem', '1.0', source: 'https://gems.example.com'
gem 'nokogiri', git: 'https://github.com/tenderlove/nokogiri.git', branch: '1.4'
gem 'another_gem', github: 'username/another_gem'
gem 'extracted_library', path: './vendor/extracted_library'

gem 'pry', group: :development

group :test do
  gem 'faker'
  gem 'rspec', require: false
end

group :test, :development do
  gem 'capybara'
  gem 'shoulda-matchers'
end
```

```bash
$ bundle install
$ bundle install --without test development
$ bundle update
```

---

# Semantic Versioning

Given a version number `MAJOR.MINOR.PATCH`, increment the:

- `MAJOR` version when you make incompatible changes
- `MINOR` version when you add functionality in a backwards-compatible manner
- `PATCH` version when you make backwards-compatible bug fixes

--

# Specifying versions

```ruby
gem 'nokogiri'
gem 'rails', '3.0.0.beta3'
gem 'rack',  '>= 1.0'
gem 'thin',  '~> 2.0.3'
```

> Most of the version specifiers, like `>= 1.0`, are self-explanatory.
  The specifier `~>` has a special meaning, best shown by example.

- `~> 2.0.3` is identical to `>= 2.0.3` and `< 2.1`
- `~> 2.1` is identical to `>= 2.1` and `< 3.0`
- `~> 2.2.beta` will match prerelease versions like `2.2.beta.12`

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
$ rvm use 2.4.2@create_gem --create
ruby-2.4.2 - #gemset created ~/.rvm/gems/ruby-2.4.2@create-gem
ruby-2.4.2 - #generating create-gem wrappers - please wait
Using ~/.rvm/gems/ruby-2.4.2 with gemset create-gem
```

Installing bundler

```bash
$ gem i bundler
```

---

# Creating gem with bundler

```bash
$ bundle gem new_gem
Creating gem 'new_gem'...
MIT License enabled in config
      create  new_gem/Gemfile
      create  new_gem/lib/new_gem.rb
      create  new_gem/lib/new_gem/version.rb
      create  new_gem/new_gem.gemspec
      create  new_gem/Rakefile
      create  new_gem/README.md
      create  new_gem/bin/console
      create  new_gem/bin/setup
      create  new_gem/.gitignore
      create  new_gem/.travis.yml
      create  new_gem/.rspec
      create  new_gem/spec/spec_helper.rb
      create  new_gem/spec/new_gem_spec.rb
      create  new_gem/LICENSE.txt
Initializing git repo in ~/projects/create_gem/new_gem
```

---

# Gem structure

```bash
$ tree -a -F -L 3 --dirsfirst
.
├── bin/
├── lib/
│   ├── new_gem/
│   │   └── version.rb
│   └── new_gem.rb
├── spec/
│   ├── new_gem_spec.rb
│   └── spec_helper.rb
├── .gitignore
├── .rspec
├── .travis.yml
├── Gemfile
├── LICENSE.txt
├── README.md
├── Rakefile
└── new_gem.gemspec
```

---

## Gemspec

new_gem.gemspec <!-- .element class="filename" -->

```ruby
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "new_gem/version"

Gem::Specification.new do |spec|
  spec.name          = "new_gem"
  spec.version       = NewGem::VERSION
  spec.authors       = ["Dmitriy Grechukha"]
  spec.email         = ["dmitriy.grechukha@gmail.com"]

  spec.summary       = %q{Write a short summary, because RubyGems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://rubygarage.org"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
```

---

# Gem structure

lib/new_gem/version.rb <!-- .element class="filename" -->

```ruby
module NewGem
  VERSION = '0.1.0'
end
```

Gemfile <!-- .element class="filename" -->

```ruby
source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in new_gem.gemspec
gemspec
```

new_gem.gemspec <!-- .element class="filename" -->

```ruby
# ...
Gem::Specification.new do |spec|
  # ...
  spec.add_dependency 'sqlite3'
  spec.add_development_dependency 'rspec'
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
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec
```

---

# Build and push gem to RubyGems.org

Rakefile <!-- .element class="filename" -->

```ruby
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec
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
new_gem 0.1.0 built to pkg/new_gem-0.1.0.gem
```

---

# Control questions

- What is `gem`?
- What is `bundler`?
- What is `Gemfile`?
- What is `Gemfile.lock`?
- How to create a `gem`?
- What is `gemspec`?
- What is `RubyGems.org`?

---

# The End
