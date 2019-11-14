---
layout: slide
title:  Install Rspec
---

# Adding specs to the project

<img src="/assets/images/install-rspec/rspec.png"  width="240" height="240">

---
## Gem `rspec-rails`

`rspec-rails` brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework, Minitest.

---

## Install `rspec-rails`

The first thing we need to do is add our gem to Gemfile in `:development, :test` groups

```ruby
group :development, :test do
  gem "rspec-rails"
end
```

Then, run `bundle` to download and instal new gem

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

--

### What is `spec_helper.rb`?
`spec_helper.rb` - is for specs which don't depend on Rails (such as specs for classes in the lib directory).

### What is `rails_helper.rb`?
`rails_helper.rb` - is for specs which do depend on Rails (in a Rails project, most or all of them). rails_helper.rb requires spec_helper.rb

---

## RSpec best practice

Best practice include ideas how to improve your specs quality and increase efficiency of your BDD workflow.

--

### `describe`

Be clear about what method you're describing. For instance, use the ruby documentation convention of `.` when referring to a class method's name and `#` when referring to an instance method's name.

```ruby
### Bad example
describe 'the authenticate method for User' do
describe 'if the user is an admin' do

### Good example
describe '.authenticate' do
describe '#admin?' do
```

--

### `context`

`context` starts either with `"with"` or `"when"`, such "when status is pending"

```ruby
describe '#status_badge' do
  context 'returns css class based on status' do
    context 'when status is pending' do
      let(:request_status) { 'pending' }

      it 'returns css for grey badge' do
        expect(subject.status_badge).to eql 'c-badge--grey'
      end
    end
  end
end
```

--

### `it`
`it` describes a test case (one expectation) and specify only one behavior. Multiple expectations in the same example are signal that you may be specifying multiple behaviors. By specify only have one expectation, helps you on finding possible errors, going directly to the failing test, and to make your code readable.

```ruby
it { is_expected.to belong_to(:job_title).class_name('JobTitle').optional }
```

or

```ruby
it 'has relations' do
  is_expected.to belong_to(:job_title).class_name('JobTitle').optional
end
```

--

### `subject`

`subject` makes way clearer about what you're actually testing and helps you stay DRY in your tests

```ruby
describe Book do
  describe '#valid_isbn?' do
    subject { Book.new(isbn: isbn).valid_isbn? }

    context 'with a valid ISBN number' do
      let(:isbn) { 'valid' }

      # ...
    end
  end
end
```

--

### `Mocking`

`mocking` is interesting and usually we're doing mocking when the scenario which we want to test require another service.

You may mock just everything so your spec will never hit the database or another service. But, this is something wrong. When your model code changed or the initiliaze method of service you are call changed, your code will break without get failing specs before merge to production.

app/models/post_info.rb <!-- .element: class="filename" -->

```ruby
class PostInfo do
  #...
  def allow?
    current_company.active_subscribe?
  end
end
```

spec/models/post_info_spec.rb <!-- .element: class="filename" -->

```ruby
RSpec.describe PostInfo do
  before do
    allow_any_instance_of(Company).to receive(:active_subscribe?).and_return true
  end

  it ... do
  #..
end
```

--

## Custom matchers

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
require 'rails_helper'

RSpec.feature "Mainpages", type: :feature do
  pending "add some scenarios (or delete) #{__FILE__}"
end
```

--

### RSpec give us some new methods, lets look

- `describe` - The describe method creates an example group. Within the block passed to
describe you can declare nested groups using the describe method. Use describe to separate methods being tested or behavior being tested.

- `context` - alias `describe`, but you can use it if you want to separate specs based on conditions.

- `it` - create a test block with RSpec, where we write our expectation.

- `specify` - alias `it`, but you can use it to make your tests more readable.

If you're writing feature tests with `Capybara`, use the `feature` / `scenario` syntax, if not use `describe` / `it` syntax.

--

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

--

### What is `matcher`?

A matcher is any object that responds to the following methods:

```ruby
matches?(actual)
failure_message
```
Types od matchers:

- `Object identity`

- `Object equivalence`

- `Optional APIs for identity/equivalence`

- `Comparisons`

- `Types/classes/response`

- `...`

About of different type matchers you can read [here](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)

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