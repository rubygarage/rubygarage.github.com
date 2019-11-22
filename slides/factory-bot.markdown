---
layout: slide
title: Factory Bot
---

## What is Factory Bot?

factory_bot is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

---

## Install `factory_bot_rails`

The first thing we need to do is add our gem to Gemfile in `:test` group

```ruby
group :test do
  gem "factory_bot_rails"
end
```

Then, run `bundle` to download and instal new gem

```bash
$ bundle install
```

Define config file:

spec/support/factory_bot.rb <!-- .element: class="filename" -->

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

We need include a support folder for rspec. Add following line down the file `rails_helper.rb` this will
tell rails to load the modules under the `spec/support`.

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }
```

--

### Automatic Factory Definition Loading

By default, `factory_bot_rails` will automatically load factories defined in the following locations, relative to the root of the Rails project:

```ruby
factories.rb
test/factories.rb
spec/factories.rb
factories/*.rb
test/factories/*.rb
spec/factories/*.rb # good
```

---

### Defining factories

Each factory has a name and a set of attributes. The name is used to guess the class of the object by default:

spec/factories/user_factory.rb <!-- .element: class="filename" -->

```ruby
# This will guess the User class

FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

It is also possible to explicitly specify the class:

```ruby
# This will use the User class (otherwise Admin would have been guessed)
factory :admin, class: User
```

---

### Using factories

`factory_bot` supports several different build strategies: build, create, attributes_for and build_stubbed:

```ruby
# Returns a User instance that's not saved
user = build(:user)

# Returns a saved User instance
user = create(:user)

# Returns a hash of attributes that can be used to build a User instance
attrs = attributes_for(:user)

# Returns an object with all defined attributes stubbed out
stub = build_stubbed(:user)

# Passing a block to any of the methods above will yield the return object
create(:user) do |user|
  user.posts.create(attributes_for(:post))
end
```

---

### Inheritance

You can easily create multiple factories for the same class without repeating common attributes by nesting factories:

```ruby
factory :post do
  title { "A title" }
  approved { false }

  factory :approved_post do
    approved { true }
  end
end
```

```bash
post = create(:post)
post.title             # => "A title"
post.approved          # => false

approved_post = create(:approved_post)
approved_post.title    # => "A title"
approved_post.approved # => true
```

---

### Associations

It's possible to set up associations within factories.

spec/factories/author.rb <!-- .element: class="filename" -->

```ruby
factory :author do
  # ...
  name { "Bender" }
end
```
spec/factories/post.rb <!-- .element: class="filename" -->

```ruby
factory :post do
  # ...
  association :author # this line will create association post with factory author
end
```

```bash
post = create(:post)
post.author.name # => "Bender"
```

You can also specify a different factory or override attributes:

spec/factories/post.rb <!-- .element: class="filename" -->

```ruby
factory :post do
  # ...
  association :author, factory: :user, last_name: "Writely"
end
```

--

### `Parent strategy`

In factory_bot 5, associations default to using the same build strategy as their parent object:

```ruby
FactoryBot.define do
  factory :author

  factory :post do
    author
  end
end

# Builds an Author, and then builds a Post, but does not save either
post = build(:post)
post.new_record?        # => true
post.author.new_record? # => true

# Builds and saves an Author, and then builds and saves a Post
post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false
```

`build(:post)` won't save the object, but will still make requests to a database if the factory has 

associations. It will trigger validations only for associated objects.

--

### `use_parent_strategy`

This is different than the default behavior for previous versions of factory_bot, where the association strategy would not always match the strategy of the parent object. If you want to continue using the old behavior, you can set the `use_parent_strategy` configuration option to `false`.

spec/support/factory_bot.rb <!-- .element: class="filename" -->

```ruby
FactoryBot.use_parent_strategy = false
```

```ruby
FactoryBot.define do
  factory :author

  factory :post do
    author
  end
end

# Builds and saves a Author, and then builds but does not save a Post
post = build(:post)
post.new_record?        # => true
post.author.new_record? # => false

# Builds and saves a Author and a Post
post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false
```

---

### Sequences

Unique values in a specific format (for example, e-mail addresses) can be generated using sequences. Sequences are defined by calling sequence in a definition block, and values in a sequence are generated by calling generate:

```ruby
# Defines a new sequence
FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

generate :email
# => "person1@example.com"
```

And it's also possible to define an in-line sequence that is only used in a particular factory:

```ruby
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end

# creates a user with email "person1@example.com"
create(:user)
```

You can also override the initial value:

```ruby
factory :user do
  sequence(:email, 1000) { |n| "person#{n}@example.com" }
end
```

---

### Traits

Traits allow you to group attributes together and then apply them to any factory.

```ruby
factory :user do
  name { "Friendly User" }

  trait :male do
    name { "John Doe" }
    gender { "Male" }
  end

  trait :female do
    name { "Stacy Leeds" }
    gender { "Female" }
  end

  trait :admin do
    admin { true }
  end
end

# creates an admin user with gender "Male" and name "Robert Snow"
create(:user, :admin, :male, name: "Robert Snow")

# creates a user with gender "Female" and name "Stacy Leeds"
create(:user, :female)
```

--

With traits you can group attributes together and then apply them to any factory.

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :male do
    name { "John Doe" }
    gender { "Male" }
    login { "#{name} (M)" }
  end

  trait :female do
    name { "Jane Doe" }
    gender { "Female" }
    login { "#{name} (F)" }
  end

  trait :admin do
    admin { true }
    login { "admin-#{name}" }
  end

  factory :male_admin,   traits: [:male, :admin]   # login will be "admin-John Doe"
  factory :female_admin, traits: [:admin, :female] # login will be "Jane Doe (F)"
end
```

`Note` the trait that defines the attribute latest gets precedence.

--

`Polymorphic associations` can be handled with traits:

```ruby
FactoryBot.define do
  factory :video
  factory :photo

  factory :comment do
    for_photo # default to the :for_photo trait if none is specified

    trait :for_video do
      association :commentable, factory: :video
    end

    trait :for_photo do
      association :commentable, factory: :photo
    end
  end
end
```

This allows us to do:

```ruby
create(:comment)
create(:comment, :for_video)
create(:comment, :for_photo)
```

---

### Callbacks

`factory_bot` makes available `four callbacks` for injecting some code:

- `after(:build)` - called after a factory is built (via FactoryBot.build, FactoryBot.create)

- `before(:create)` - called before a factory is saved (via FactoryBot.create)

- `after(:create)` - called after a factory is saved (via FactoryBot.create)

- `after(:stub)` - called after a factory is stubbed (via FactoryBot.build_stubbed)

For more info about call back, you can read [here](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#configure-your-test-suite)

--

Examples:

```ruby
# Define a factory that calls the generate_hashed_password method after it is built
factory :user do
  after(:build) { |user| generate_hashed_password(user) }
end
```

You can also define multiple types of callbacks on the same factory:

```ruby
factory :user do
  after(:build)  { |user| do_something_to(user) }
  after(:create) { |user| do_something_else_to(user) }
end
```

Factories can also define any number of the same kind of callback. These callbacks will be executed in the order they are specified:

```ruby
factory :user do
  after(:create) { this_runs_first }
  after(:create) { then_this }
end
```

`Note` calling `create` will invoke both `after_build` and `after_create` callbacks.

---

### Building or Creating Multiple Records `(collections)`

Sometimes, you'll want to create or build multiple instances of a factory at once.

```ruby
built_users   = build_list(:user, 25)
created_users = create_list(:user, 25)
```

These methods will build or create a specific amount of factories and return them as an array. To set the attributes for each of the factories, you can pass in a hash as you normally would.

```ruby
twenty_year_olds = build_list(:user, 25, date_of_birth: 20.years.ago)
```

`build_stubbed_list` will give you fully stubbed out instances:

```ruby
stubbed_users = build_stubbed_list(:user, 25) # array of stubbed users
```
