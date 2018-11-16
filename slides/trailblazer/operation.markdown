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

When you run an operation like Memo::Create.(), it will internally execute its circuit. This simply means the operation will traverse its [railway](https://fsharpforfunandprofit.com/rop/) (or pipe), call the steps you defined, deviate to different tracks, and so on.

An operation provides three DSL methods to define the circuit: `step`, `pass`, and `fail`.

![](/assets/images/trailblazer/operation-bpmn-1.png)

- `step` always puts the task on the upper, “right” track, but with two outputs per box: one to the next successful step, one to the nearest fail box. The chain of “successful” boxes in the top is the success `right track`. The lower chain is the failure `left track`.
- `pass` is on the right track, but without an outgoing connection to the left track. It is always assumed successful. The return value is ignored.
- `fail` puts the box on the failure track and doesn’t connect it back to the right track.

---

## Wiring API

---

### Fast Track

You can “short-circuit” specific tasks using a built-in mechanism called `fast track`.

--

### Fast Track: `pass_fast`

To short-circuit the successful connection of a task use :pass_fast.

```ruby
class Memo::Create < Trailblazer::Operation
  step :create_model
  step :validate,     pass_fast: true
  fail :assign_errors
  step :index
  pass :uuid
  step :save
  fail :log_errors
  # ...
end
```

If validate turned out to be successful, no other task won’t be invoked, as visible in the diagram.

![](/assets/images/trailblazer/wiring-pass-fast.png)

--

### Fast Track: `fail_fast`

The :fail_fast option comes in handy when having to early-out from the error (left) track.

```ruby
class Memo::Create < Trailblazer::Operation
  step :create_model
  step :validate
  fail :assign_errors, fail_fast: true
  step :index
  pass :uuid
  step :save
  fail :log_errors
  # ...
end
```

![](/assets/images/trailblazer/wiring-fail-fast.png)


--

### Fast Track: `fail_fast` with `step`

You can also use `:fail_fast` with `step` tasks.


```ruby
class Memo::Create < Trailblazer::Operation
  step :create_model
  step :validate
  fail :assign_errors, fail_fast: true
  step :index,         fail_fast: true
  pass :uuid
  step :save
  fail :log_errors
  # ...
end
```

![](/assets/images/trailblazer/wiring-fail-fast-step.png)

--

### Fast Track: `fast_track`

Instead of hard-wiring the success or failure output to the respective fast-track end, you can decide what output to take dynamically, in the tas. However, this implies you configure the task using the :fast_track option.

```ruby
class Memo::Create < Trailblazer::Operation
  step :create_model,  fast_track: true
  step :validate
  fail :assign_errors, fast_track: true
  step :index
  pass :uuid
  step :save
  fail :log_errors
  # ...
end
```

By marking a task with :fast_track, you can create up to four different outputs from it.

![](/assets/images/trailblazer/wiring-fast-track.png)

--

Both create_model and assign_errors have two more outputs in addition to their default ones: one to End.pass_fast, one to End.fail_fast (note that this option works with pass, too). To make the execution take one of the fast-track paths, you need to emit a special signal from that task, though.

```ruby
def create_model(options, create_empty_model:false, **)
  options[:model] = Memo.new
  create_empty_model ? Railway.pass_fast! : true
end
```

---

## Signals

A signal is the object that is returned from a task. It can be any kind of object, but per convention, we derive signals from `Trailblazer::Activity::Signal`. When using the wiring API with step and friends, your tasks will automatically get wrapped so the returned boolean gets translated into a signal.

```ruby
def validate(options, params: {}, **)
  if params[:text].nil?
    Trailblazer::Activity::Left  #=> left track, failure
  else
    Trailblazer::Activity::Right #=> right track, success
  end
end
```

Instead of using the signal constants directly, you may use signal helpers:

```ruby
def validate(options, params: {}, **)
  if params[:text].nil?
    Railway.fail! #=> left track, failure
  else
    Railway.pass! #=> right track, success
  end
end
```

Available signal helpers per default are `Railway.pass!`, `Railway.fail!`, `Railway.pass_fast!` and `Railway.fail_fast!`.

---

## Connections

The four standard tracks in an operation represent an extended railway. While they allow to handle many situations, they sometimes can be confusing as they create hidden semantics. This is why you can also define explicit, custom connections between tasks and even attach task not related to the railway model.

This is achieved by defining `Output` from outgoing task using target `id`.

```ruby
class Memo::Upload < Trailblazer::Operation
  step :new?, Output(:failure) => "index"
  step :upload
  step :validate
  fail :validation_error
  step :index, id: "index"
  # ...
end
```

Events like `Start.default`, and end `End.success`, can also be referenced.


![](/assets/images/trailblazer/wiring-output-by-id.png)


---

## Custom `End`

You can also wire the step’s error output to a custom end. This is incredibly helpful if your operation needs to communicate what exactly happened inside to the outer world, a pattern used in Endpoint.

The `End` DSL method will create a new end event, the first argument being the name, the second the semantic.

```ruby
class Memo::Update < Trailblazer::Operation
  step :find_model, Output(:failure) => End("End.model_not_found", :model_not_found)
  step :update
  fail :db_error
  step :save
  # ...
end
```

![](/assets/images/trailblazer/wiring-custom-end.png)


---

## Magnetic API

If you want to stay on one path but need to branch-and-return to model a decision, use the **decider pattern**.

```ruby
class Memo::Upsert < Trailblazer::Operation
  step :find_model, Output(:failure) => :create_route
  step :update
  step :create, magnetic_to: [:create_route]
  step :save
  # ...
end
```

![](/assets/images/trailblazer/wiring-magnetic-decider.png)

Magnetic API here polarizes the failure output of find_model to `:create_route`, and making create being attracted to that very polarization, the failure output “snaps” to that task automatically.

Using magnetic API you don’t need to know what is the specific target of a connection, allowing to push multiple tasks onto that new `:create_route` track.

---

### Recover pattern

Error handlers on the left track are the perfect place to “fix things”. For example, if you need to upload a file to S3, if that doesn’t work, try with Azure, and if that still doesn’t play, with Backblaze. This is a common pattern when dealing with external APIs.

You can simply put recover steps on the left track, and wire their :success output back to the right track (which the operation knows as :success).

```ruby
class Memo::Upsert < Trailblazer::Operation
  step :find_model, Output(:failure) => :create_route
  step :update
  step :create, magnetic_to: [:create_route]
  step :save
  # ...
end
```

![](/assets/images/trailblazer/wiring-recover-pattern.png)

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

Used for sharing steps

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

--

## Step options

### ID

For every kind of step, whether it’s a macro or a custom step, use `:id` (former `:name`) to specify a name.

```ruby
class New < Trailblazer::Operation
  step Model( Song, :new )
  step :validate_params
  # ..
end

# Results in
 0 =======================>>operation.new
 1 =====================&model.build
 2 ===================&validate_params
```


```ruby
class New < Trailblazer::Operation
  step Model( Song, :new ), id: "build.song.model"
  step :validate_params,   id: "my.params.validate"
  # ..
end

# Results in
 0 =======================>>operation.new
 1 =====================&build.song.model
 2 ===================&my.params.validate
```

--

### Position

Whenever inserting a step, you may provide the position in the pipe using `:before` or `:after`.

```ruby
class New < Trailblazer::Operation
  step Model( Song, :new )
  step :validate_params,   before: "model.build"
  # ..
end

 0 =======================>>operation.new
 1 =====================&validate_params
 2 ==========================&model.build
```

--

### Replace

Replace existing (only in the applied class, not in the superclass) steps using `:replace`.

```ruby
class Update < New
  step Model(Song, :find_by), replace: "model.build"
end

 0 =======================>>operation.new
 1 =====================&validate_params
 2 ==========================&model.build
```

### Delete
  ```ruby
class Update < New
  step nil, delete: 'validate_params', id: ''
end

 0 =======================>>operation.new
 1 ==========================&model.build
```

--

### Group

The `:group` option is the ideal solution to create template operations, where you declare a basic circuit layout which can then be enriched by subclasses.

```ruby
class Memo::Operation < Trailblazer::Operation
  step :log_call,  group: :start
  step :log_success,  group: :end, before: "End.success"
  fail :log_errors,   group: :end, before: "End.failure"
  # ...
end
```

Subclasses can now insert their actual steps without any sequence options needed.

Since all logging steps defined in the template operation are placed into groups, the concrete steps sit in the middle.

---

## Step Macros

Trailblazer provides predefined steps to for all kinds of business logic.

- `Contract` implements contracts, validation and persisting verified data using the model layer.
- `Nested`, `Wrap` and `Rescue` are step containers that help with transactional features for a group of steps per operation.
- All `Policy`-related macros help with authentication and making sure users only execute what they’re supposed to.
- The `Model` macro can create and find models based on input.

--

## `Model` macro

An operation can automatically find or create a model for you depending on the input, with the `Model` macro.

It sets up `ctx[:model]` as instance of class you specify with method you specified.

```ruby
class Create < Trailblazer::Operation
  step Model( User, :new ) # equivalent to ctx[:model] = User.new
  # ..
end
```

```ruby
class Create < Trailblazer::Operation
  step Model( User, :find_by ) # equivalent to ctx[:model] = User.find_by(params[:id])
  # ..
end
```

If `User.find_by` returns `nil` operiation obviously will deviate to the failure track.


#### Arbitrary finder

It’s possible to specify any finder method, which is helpful with ROMs such as Sequel. The provided method will be invoked and Trailblazer passes it the `params[:id]` value

```ruby
class Show < Trailblazer::Operation
  step Model( User, :[] ) # equivalent to ctx[:model] = User[params[:id]]
  # ..
end
```

--

## `Wrap` macro

Steps can be wrapped by an embracing step. This is necessary when defining a set of steps to be contained in a database transaction or a database lock.

You need to provide a handler which runs the wrapped section and implements the transactional code. The handler can be any callable object (or proc).
Make sure to use `Wrap() { ... }` with **curly brackets**, otherwise Ruby will swallow the block

All nested steps will simply be executed as if they were on the “top-level” pipe, but within the wrapper code. Steps may deviate to the left track, and so on.

However, the last signal of the wrapped pipe is not simply passed on to the “outer” pipe. The return value of the actual Wrap block is crucial: If it returns falsey, the pipe will deviate to left after Wrap.


```ruby
class Create < Trailblazer::Operation
  step Model(User, :new)
  step :set_company
  step Contract::Build(constant: Registrations::Contracts::Create)
  step Contract::Validate(key: :user)
  step :user_account

  step Wrap(->((ctx), *, &block) { ActiveRecord::Base.transaction { block.call } }) {
    step Contract::Persist()
    step :persist_company
    step :add_role
    fail :rollback # raises ActiveRecord::Rollback
  }
end
```

--

### Wrap with Callable

For reusable wrappers, you can also use a `Callable` object.

```ruby
class ActiveRecordTransaction
  extend Uber::Callable

  def self.call(options, *)
    ActiveRecord::Base.transaction { yield } # yield runs the nested pipe.
    # return value decides about left or right track!
  end
end
```

--

## `Rescue` macro

While you could use the Wrap() macro to catch and process exceptions, Trailblazer provides the Rescue() macro that embraces the calling of the nested activity into a `begin/rescue` block and allows to pass in a custom handler in case of an exception.

Make sure to use `Rescue() { ... }` with **curly brackets**, otherwise Ruby will swallow the block.

You may pass any number of exceptions you desire to catch, along with your `:handler` which could be instance method, lambda or callable. The handler is called automatically if an exception was raised, it receives the latter as the first positional argument, followed by a operation context.

Per default, if the handler was invoked, the operation will deviate to the left track.

--

### `Rescue` example

```ruby
class Update < Trailblazer::Operation
  step Contract::Build(constant: Accounts::ResetPasswords::Contracts::Token)
  step Contract::Validate(key: :user)

  step Rescue(JWT::InvalidAudError, JWT::DecodeError, handler: :invalid_token_handler) {
    step :verify_reset_token
  }, fail_fast: true

  step :find_user
  step Contract::Build(constant: Accounts::ResetPasswords::Contracts::Update)
  step Contract::Validate(key: :user)
  step Contract::Persist()

  def verify_reset_token(ctx, **)
    # may raise an exception
  end

  def invalid_token_handler(exception, ctx)
    ctx[:status] = :gone
  end
end
```

--

## `Nested` macro

It is possible to nest operations, as in running an operation in another.

The nested operation will, per default, only receive runtime data from the composing operation. Mutable data is not available to protect the nested operation from unsolicited input. You can use `:input` to change the data getting passed on.

After running a nested operation, its mutable data gets copied into the options of the composing operation.
Use `:output` to change that, should you need only specific values

All nested operation ends with known semantics will be automatically connected to its corresponding tracks in the outer operation

### When to use `Nested`

You should use it only for some reccuring set of tasks if they:
- are large;
- are complicated and need to leverage the railway;
- have to use `Wrap`, `Rescue` or `Nested` macros within them.

In all other cases consider using just a callable steps.

--

### `Nested` macro example

```ruby
class Checkout::Update
  step Model(Order, :find_by)
  step Contract::Build(constant: Checkout::Contract::Update)
  step Contract::Validate(key: :order), fail_fast: true

  # ...updates order state

  success :calculate_taxes!
  success Nested(Checkout::TaxForOrder, input: Checkout::Lib::Input::TaxData)

  # ...other calculations

  step Contract::Persist()

  def calculate_taxes!(options, model:, **)
    options['calculate_taxes'] = !model.test? && model.store.tax_setting_enabled?
  end

  # ...
end
```

--

### `Nested` operation example

```ruby
class Checkout::TaxForOrder < Trailblazer::Operation
  step :calculate_taxes?

  step :from_address!
  step :to_address!
  step :assign_params!

  step Rescue(handler: :add_error!) {
    step :send_request! # reauest to third-party API
    success :assign_order_tax_amount!
    success :assign_line_items_tax_amount!
  }

  def calculate_taxes?(calculate_taxes:, **)
    calculate_taxes ? Railway.pass! : Railway.pass_fast!
  end

  # ...

  def add_error!(exception, options)
    options['contract'].errors.add(:taxjar, exception.message)
  end
end
```

--

### `Nested` `:input` example

Could be implementes as method, lambda or callable.

```ruby
module Lib
  module Input
    class TaxData
      extend Uber::Callable

      def self.call(ctx, model:, calculate_taxes:, **)
        {
          'model' => model,
          'contract' => ctx['contract.default'],
          'calculate_taxes' => calculate_taxes
        }
      end
    end
  end
end
```

`:output` could be defined the same way, only difference that it defines output from nested operations, so it arguments will hold its context.

---

## Macro API

Implementing your own macros helps to create reusable code.
It’s advised to put macro code into namespaces to not pollute the global namespace.

The macro itself is a function. Per convention, the **name is capitalized**. You can specify any set of arguments (positional or kw-args), and it returns a 2-element array with the actual step to be inserted into the pipe and default options.

Note that in the macro, the code design is up to you. You can delegate to other functions, objects, etc.

The macro step receives (input, options) where input is usually the operation instance and options is the context object passed from step to step. It’s your macro’s job to read and write to options. It is not advisable to interact with the operation instance.


```ruby
module Macros
  def self.FindModel!(class)
    step = -> (input, ctx) { ctx[:model] = class.find_by!(ctx[:params][:id]) }

    [step, name: 'model.build']
  end
end

class Update < Trailblazer::Operation
  step Macro::FindModel!(User)
  # ...
end
```

---

## Dependencies

All class data, state and dependencies of operation are stored in *context object*. It can be accessed not only at runtime inside steps, but on class layer as well:

```ruby
module Song
  class Create < Trailblazer::Operation
    self["my.model.class"] = Song
    # ...
  end
end

Song::Create["my.model.class"] #=> Song
```

All this class and runtime data can be overridden using dependency injection.

```ruby
result = Song::Create.(params: params, "my.model.class" => Hit)
```

The operation also supports Dry.RB’s `auto_inject`.

---

## Inheritance

It's possible but **not advised** to use inheritance share to code and pipe.

```ruby
class New < Trailblazer::Operation
  step Model( Song, :new )
  step Contract::Build( constant: MyContract )
end
```

```ruby
class Create < New
  step Contract::Validate()
  step Contract::Persist()
end
```

This will result in following pipe (first three steps came from `New` operation):

```
 0 =======================>>operation.new
 1 ==========================&model.build
 2 =======================>contract.build
 3 ==============&contract.default.params
 4 ============&contract.default.validate
 5 =========================&persist.save
```

Subclasses can now override predefined steps with `:override`.

```ruby
class New < MyApp::Operation::New
  step Model( Hit, :new ), override: true
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

--

### Primary Binary State

The primary state is decided by the activity’s end event superclass. If derived from `Railway::End::Success`, it will be interpreted as successful, and `result.success?` will return true, whereas a subclass of `Railway::End::Failure` results in the opposite outcome. Here, `result.failure?` is true.

You can access the end event the Result wraps via `event`. This allows to interpret the outcome on a finer level and without having to guess from data in the operation context, using Endpoint.

```ruby
result = Create.( params )

result.event #=> #<Railway::FastTrack::PassFast ...>
```

---

# The End
