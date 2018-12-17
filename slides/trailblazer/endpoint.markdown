---
layout: slide
title: Operation Contract
---

# Trailblazer Endpoint

---

`Endpoint` defines possible outcomes when running an operation and provides a neat matcher mechanism using the dry-matcher gem to handle those predefined scenarios.

It's unstable and might change, so this guide is for the master branch.

```ruby
gem 'trailblazer-endpoint', github: 'trailblazer/trailblazer-endpoint'
```

---

It replaces the following common pattern with a clean, generic mechanic:

```ruby
result = Song::Create.(...)

if result.success? && ....
  # do this
elsif result.success? && something_else
  # do that
elsif
```

In place of hard-to-read and hard-wired decider trees, a simple pattern matching happens behind the scenes.

```ruby
Trailblazer::Endpoint.new.(result) do |match|
  match.success         { |result| puts "Model #{result["model"]} was created successfully." }
  match.unauthenticated { |result| puts "You ain't root!" }
end

# or

Trailblazer::Endpoint.(Song::Create, custom_handlers, operation_args) do |m|
  # ...
end
```

---

## Outcomes

Possible pre-defined outcomes are:

- `not_found` when a model via Model configured as :find_by is not found.
- `unauthenticated` when a policy via Policy reports a breach.
- `created` when an operation successfully ran through the pipetree to create one or more models.
- `success` when an operation was run successfully.
- `present` when an operation is supposed to load model that will then be presented.

All outcomes are detected via a Matcher object implemented in the endpoint gem using pattern matching to do so.

Please note that in the current state, those heuristics are still work-in-progress, so it is advised to use your own outcomes.

---

## Handlers

Handlers are passed as proc

```ruby
MyHandlers = ->(match) do
  match.success         { |result| puts "Model #{result["model"]} was created successfully." }
  match.unauthenticated { |result| puts "You ain't root!" }
end

Trailblazer::Endpoint.new.(result, MyHandlers)
```

Or as block that takes precedence over proc

```ruby
Trailblazer::Endpoint.new.(result, MyHandlers) do |match|
  match.unauthenticated { |result| raise "Break-in!" }
end

```
---

## Specifying outcomes

Outcomes are defined by matchers.

There is no way to define them on the fly, so you have to inherit `Trailblazer::Endpoint` and override `matchers`

```ruby
class Endpoint < Trailblazer::Endpoint
  Matcher = Dry::Matcher.new(
    destroyed: Dry::Matcher::Case.new(
      match:   ->(result) { result.success? && result[:model].try(:destroyed?) },
      resolve: ->(result) { result }
    ),
    success: Dry::Matcher::Case.new(
      match:   ->(result) { result.success? },
      resolve: ->(result) { result }
    ),
    created: Dry::Matcher::Case.new(
      match:   ->(result) { result.success? && result['model.action'] == :new },
      resolve: ->(result) { result }
    ),
    not_found: Dry::Matcher::Case.new(
      match:   ->(result) { result.failure? && result[:model].nil? },
      resolve: ->(result) { result }
    ),
    invalid: Dry::Matcher::Case.new(
      match:   ->(result) { result.failure? && result['result.contract.default'] && result['result.contract.default'].failure? },
      resolve: ->(result) { result }
    )
  )

  def matcher
    Endpoint::Matcher
  end
end
```

---

# The End
