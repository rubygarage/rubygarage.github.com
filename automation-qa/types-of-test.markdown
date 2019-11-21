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

--

## End-to-End testing

End-to-end testing is a technique used to test whether the flow of an application right from start to finish is behaving as expected. The purpose of performing end-to-end testing is to identify system dependencies and to ensure that the data integrity is maintained between various system components and systems.

The entire application is tested for critical functionalities such as communicating with the other systems, interfaces, database, network, and other applications.

--

For example, we created simple End-to-End test with one `scenario` block:

spec/features/end_to_end_spec.rb <!-- .element: class="filename" -->

```ruby

describe 'End to End', type: :feature do
  scenario 'login, buy book and logout' do
    visit(root_path)

    expect(page).to have_content('Bookstore')

    find('Sign up').click
  
    fill_in 'user', with: 'User'
    fill_in 'password', with: '1234'
    click_button 'Sign up'

    expect(page).to have_content('Sign out')

    find('#second_book').click

    expect(page).to have_content('Second book')

    find('.buy_button').click

    expect(find_field('cart_count').value).to eq '1'
    
    find('Checkout').click

    expect(page).to have_current_path checkout_path

    fill_in 'address', with: 'str Dneprovskaya 17'
    fill_in 'postal_code', with: '52000'
    click_button 'Complete'

    expect(page).to have_content('Checkout complete!')

    find('Log out').click

    expect(page).not_to have_content('Sign out')
  end
end
```

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