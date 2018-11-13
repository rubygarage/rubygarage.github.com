---
layout: slide
title:  Trailblazer Operation
---

# Trailblazer Operation

---

# Operation

An operation is a **service object**.

Its goal is simple: Remove all business logic from the controller and model and provide a separate, streamlined object for it.

Operations implement functions of your application, like creating a comment, following a user or exporting a PDF document. Sometimes this is also called command.

Technically, an operation embraces and orchestrates all business logic between the controller dispatch and the persistence layer. This ranges from tasks as finding or creating a model, validating incoming data using a form object to persisting application state using model(s) and dispatching post-processing callbacks or even nested operations.

Note that an operation is not a monolithic god object, but a composition of many stakeholders. It is up to you to orchestrate features like policies, validations or callbacks.


---

## Operation implementation

```ruby
class Create < Trailblazer::Operation
  step Contract::Build(constant: Sessions::Contracts::Create)
  step Contract::Validate(key: :auth), fail_fast: true

  step :model
  step :authenticate
  fail :unauthenticated
  step :confirmed?
  fail :unconfirmed
  step :create_tokens

  def model(ctx, **)
    ctx[:model] = UserProfile.find_by(email: ctx['contract.default'].email)
  end

  def authenticate(ctx, model:, **)
    model.user_account.authenticate(ctx['contract.default'].password)
  end

  def unauthenticated(ctx, **)
    ctx['contract.default'].errors.add(:base, I18n.t('errors.session.wrong_credentials'))
  end

  def confirmed?(_ctx, model:, **)
    model.user_account.confirmed_at
  end

  def unconfirmed(ctx, **)
    ctx['contract.default'].errors.add(:base, I18n.t('errors.session.confirmation_error'))
  end

  def create_tokens(ctx, model:, **)
    # ...
  end
end
```

---

## Flow control

The flow of an operation is defined by a two-tracked pipeline.

The operation’s sole purpose is to define the pipe with its steps that are executed when the operation is run. While traversing the pipe, each step orchestrates all necessary stakeholders like policies, contracts, models and callbacks.

Per default, the success track will be run from start to end. If an error occurs, it will deviate to the fail track and continue executing error handler steps on this track.

![](/assets/images/trailblazer/operation-bpmn-1.png)

The following high-level API is available.

- `step` adds a step to the right track. If its return value is falsey, the pipe deviates to the left track. Can be called with macros, which will run their own insertion logic.
- `pass` (or `success`) always add step to the success-track. The return value is ignored.
- `fail` (or `failure`) always add step to the fail-track for error handling. The return value is ignored.

---

## Step API

A step can be added via `step`, `pass` and `fail`.

Step should receive `ctx` - mutable operation context object which transports mutable state from one step to the next, as first positional argument. All runtime data is also passed as keyword arguments to the step. Use the positional options to write, and make use of kw-arguments wherever possible - extract the parameters you need (such as `params:`). Any unspecified kw-arguments can be ignored using `**`.



Step can be implemented as: An instance method, lambda, callable, or use macros.

--

### An instance method

```ruby
class Create < Trailblazer::Operation
  step :authenticate

  def authenticate(ctx, model:, **)
    model.user_account.authenticate(ctx['contract.default'].password)
  end
end
```

--

### Lambda

Don't do this

```ruby
class Create < Trailblazer::Operation
  step ->(ctx, model:, **) { model.user_account.authenticate(ctx['contract.default'].password) }
end
```

--

### Callable

```ruby
class Authenticate
  extend Uber::Callable #

  def self.call(ctx, model:, **)
    model.user_account.authenticate(ctx['contract.default'].password)
  end
end

class Create < Trailblazer::Operation
  step Authenticate
end
```

---

## Operation invokation

Operations are usually invoked straight from the controller action. They orchestrate all domain logic necessary to perform the app's function.

Operation public interface is only one method - `Operation.call`, all runtime data should be passed to it as kw-arguments, like `params, current_user, etc.`.

It returns the `result object` that contains all the data from operation's context, including injected and class dependenciess. result object exposess `success?` and `failure?` methods that allows to check on which track operation has ended.

Data from the context could be read from it: `result[:model]`. Some data is stored by convention `'namespaced.key'` like  `result['contract.default']`.

```ruby
class SessionsController < ApplicationController
  def create
    result = Sessions::Operations::Create.(params: params)
    if result.success?
      render json: result[:representer].new.render(result[:model], result[:renderer_options]).to_json,
              status: :created
    else
      render_json_api_errors(result, status: :unauthorized)
    end
  end
end
```

---
