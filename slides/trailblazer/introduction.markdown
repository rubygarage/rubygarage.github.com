---
layout: slide
title:  Trailblazer Introduction
---

# Trailblazer Introduction

ver. 2.1.rc1

---

## What is Trailblazer

It’s a business logic framework.

---

## Pros of using Trailblazer

- provides new high-level abstractions for Ruby frameworks extending basic MVC pattern;
- gently enforces encapsulation;
- enforces an intuitive code structure;
- gives you an object-oriented architecture;
- sets conventions that go far beyond database table naming or route paths;
- lets you focus on your application code, minimize bugs and improve the maintainability.

---

## Trailblazer brings new abstractions

![](/assets/images/trailblazer/operation-abstractions.png)

--

## Trailblazer layers

- **OPERATION** A service object implementation with functional flow control.
- **CONTRACT** Form objects to validate incoming data.
- **POLICY** to authorize code execution per user.
- **VIEW MODEL** Components for your view code.
- **REPRESENTER** for serializing and parsing API documents.
- **DESERIALIZER** Transformers to parse incoming data into structures you can work with.


---


## What problems does it solve?

- Bloated controllers
- Unstructured services
- Cumbersome error handling

---

### Bloated controllers.

After applying Trailblazer architecture, controllers end up as lean HTTP endpoints. No business logic is to be found in the controller, they instantly delegate to their respective operation. By standardizing the business logic, new developers can be onboarded faster. Trailblazer’s patterns cover 75% of daily business code’s structure.

--

### Delegated business logic

```ruby
class SampleController < ApplicationController
  def create
    result = Samples::Operations::Create.(params: params)
    render json: result[:response]), status: result[:status]
  end
end
```

---

### Unstructured services

Services that are implemented in different styles and don't follow any convention are hard to understand, maintain and refactor.

--

## Code Structure

Trailblazer’s file structure organizes by **CONCEPT**, and then by technology. It embraces the **COMPONENT STRUCTURE** of your code. The modular structure SIMPLIFIES REFACTORING in hundreds of legacy production apps. To avoid constants naming collision with your active_record models it’s better to name your concepts using plurals nouns.

Trailblazer operation also has a unified interface, so there would be no more diversity in your services API.

--

![](/assets/images/trailblazer/code-structure.png)

---

### Error handling

Typical application contains some data and some set of operations performed on it. Usually, errors in an imperative language are handled by `try-catch` or checking that each operation(function) returned as expected and if not then return error. This causes a lot of defensive coding by adding a lot of `if`'s into the code hence making it difficult to reason about.

--
## Railway oriented programming

Trailblazer uses railway oriented programming pattern to solve this.

Railway oriented programming is a design pattern which helps us handle errors in our applications. Instead of relying on exceptions, we design our data and functions in a specific way.

We can avoid cumbersome exceptions logic by changing our application business logic flow to  the two-tracks railway - failure and success. Operations would be placed on success track for business logic, and on failure track for error handling. Operations on the success track would proceed onwards when there are no errors and would just switch track in case of failure, and bypass all remaining success logic.

![](/assets/images/trailblazer/railway-2.png)
![](/assets/images/trailblazer/railway-1.png)

In 2.1 release it’s possible to use more than two tracks (fail/success).

---

## Why do we need it?

Trailblazer defines patterns for a better architecture and gives you implementations to use those patterns in your applications. Your software will be better structured, more consistent and with stronger, faster, and way simpler tests.

---

## Prerequisites

This course ends with Rails API integration slideshow and task, so it is recommended to get acknowledged with the following tools:

- [dry-validation](https://dry-rb.org/gems/dry-validation/) - validations for Ruby;
- [dry-types](https://dry-rb.org/gems/dry-types/) - type system for Ruby;
- [dry-matcher](https://dry-rb.org/gems/dry-matcher/) - dry-matcher offers flexible, expressive pattern matching for Ruby;
- [JSON:API](https://jsonapi.org/) and [JSONAPI-RB](http://jsonapi-rb.org/) - a specification for building APIs in JSON and JSON:API library for ruby
- [json_matchers](https://github.com/thoughtbot/json_matchers) - matchers to validate JSON returned by your Rails JSON APIs;
- [dox](https://github.com/infinum/dox) - automated API documentation from Rspec.
---

# The End
