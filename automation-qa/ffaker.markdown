---
layout: slide
title:  FFaker
---

# FFaker

---

## What is FFaker?

It is gem that provides you easily generate fake data: names, addresses, phone numbers, etc.

https://github.com/ffaker/ffaker

---

## How to install

Gemfile <!-- .element: class="filename" -->

```ruby
group :test do
  gem 'ffaker', '~> 2.13'
end
```

Bash <!-- .element: class="filename" -->

```bash
$ bundle install
```

---

## How to use

spec/rails_helper.rb <!-- .element: class="filename" -->

```ruby
require 'ffaker'
```

### Generate fake data

```ruby
FFaker::Book.title  # 'Legend of Blue Women'
FFaker::Address.street_address  # '25309 Zemlak Corner'
FFaker::Name.name  # 'Joshua Runolfsson'
FFaker::Avatar.image # 'https://robohash.org/nonminusdolorum.png?size=300x300'
```

--

### Using with Rspec let()

```ruby
context 'test' do
  let(:phone_number) { FFaker::PhoneNumberAU.phone_number }
  let(:product) { FFaker::Product.brand }
end
```

### Using with FactoryBot

```ruby
FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    avatar_url { FFaker::Avatar.image }
  end
end
```

---

# ffaker vs faker

The faker and ffaker APIs are basically the same, but ffaker is a refactored faker, and it takes more people and time to develop it

---

## Where you can find how to create any fake data

https://github.com/ffaker/ffaker/blob/master/REFERENCE.md

---

# The End
