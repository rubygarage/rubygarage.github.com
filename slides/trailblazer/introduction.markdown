---
layout: slide
title:  Trailblazer Introduction
---

# Trailblazer Introduction

---

# What is Trailblazer

It’s a business logic framework.
Trailblazer provides new high-level abstractions for Ruby frameworks. It gently enforces encapsulation, an intuitive code structure and gives you an object-oriented architecture.
Trailblazer gives you a high-level architecture for web applications. It extends the basic MVC pattern with new abstractions. Conventions that go far beyond database table naming or route paths let you focus on your application code, minimize bugs and improve the maintainability.


---

## Trailblazer brings new abstractions

![](/assets/images/trailblazer/operation-abstractions.png)

--

- **OPERATION** A service object implementation with functional flow control.
- **CONTRACT** Form objects to validate incoming data.
- **POLICY** to authorize code execution per user.
- **VIEW MODEL** Components for your view code.
- **REPRESENTER** for serializing and parsing API documents.
- **DESERIALIZER** Transformers to parse incoming data into structures you can work with

---

## What problem it solves?

Bloated controllers.
After applying Trailblazer architecture controllers end up as lean HTTP endpoints. No business logic is to be found in the controller, they instantly delegate to their respective operation. By standardizing the business logic, new developers can be onboarded faster with help of free documentation. Trailblazer’s patterns cover 75% of daily business code’s structure - you will feel the power of strong conventions within the first hours.

---

## Why do we need it?

Trailblazer defines patterns for a better architecture, and gives you implementations to use those patterns in your applications. Your software will be better structured, more consistent and with stronger, faster, and way simpler tests.

---

# Other concepts behind Trailblazer

---

## Railway oriented programming

Trailblazer uses railway oriented programming pattern. And in 2.1 release it’s possible to use more than two tracks (fail/success)
Railway oriented programming is a design pattern which helps us handle errors in our applications. Instead of relying on exceptions, we design our data and functions in a specific way.

--

### What's the matter

Typical application contains some data and some set of operations performed on it. Usually errors in an imperative language are handled by try catch or checking that the each operation(function) returned as expected and if not then return error. This causes a lot of defensive coding by adding a lot of if into the code hence making it difficult to reason about

--

We can avoid this by changing our application business logic flow to two-tracks railway - failure and success. Operations would be placed on succes track for business logic, and on failure track for error handling. Operations on the success track would proceed onwards when there is no errors and would just switch track in case of failure, and bypass all remaining success logic.

![](/assets/images/trailblazer/railway-2.png)
![](/assets/images/trailblazer/railway-1.png)

---

## Code Structure

Trailblazer’s file structure organizes by **CONCEPT**, and then by technology. It embraces the **COMPONENT STRUCTURE** of your code. The modular structure SIMPLIFIES REFACTORING in hundreds of legacy production apps. To avoid constants naming collision with your active_record models it’s better to name your concepts using plurals nouns.

--

![](/assets/images/trailblazer/code-structure.png)

---

# The End
