---
layout: slide
title:  Rails Test Types
---

## What are `test types`?

- `Unit` tests

- `Integration` tests

- `Hybrid` tests

![](/assets/images/types-of-test/rails-test-types.png)

---

## Unit tests
All these different tests fall along a spectrum. At one end are unit tests. These test individual components in isolation, proving that they implement the expected behavior independent of the surrounding system. Because of this, unit tests are usually small and fast. Examples of unit tests are model and view specs.

---

## Integration tests
These tests exercise the system as a whole rather than its individual components. They typically do so by simulating a user trying to accomplish a task in our software. Instead of being concerned with invoking methods or calling out to collaborators, integration tests are all about clicking and typing as a user.

---

## Hybrid tests
Many test types are neither purely unit nor integration tests. Instead, they lie somewhere in between, testing several components together but not the full system. For example, controller specs generally test some aspect of the model and helper layers in addition to the controller itself.

---

## Rails Test Types include

- Unit tests

 - View Specs

 - Helper Specs

 - Model Specs

- Hybrid tests

 - Controller Specs

- Integration tests

 - Requests Specs

 - Feature Specs

---

## Feature spec

Feature specs are high-level tests meant to exercise slices of functionality
through an application. They should drive the application only via its external
interface, usually web pages.

Feature specs are marked by `type: :feature`.

Feature specs require the `Capybara` gem.