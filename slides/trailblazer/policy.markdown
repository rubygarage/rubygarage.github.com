---
layout: slide
title: Operation Contract
---

# Operation `Policy`

---

## Policy

`Policy` module allows to authorize code execution per user

It consists from `Policy::Pundit` and `Policy::Guard` modules.

---

## `Policy::Pundit`

The Policy::Pundit module allows using Pundit-compatible policy classes in an operation.

A Pundit policy has various rule methods and a special constructor that receives the current user and the current model.

```ruby
class MyPolicy
  def initialize(user, model)
    @user, @model = user, model
  end

  def create?
    @user.admin? && @model.id.nil?
  end

  def show?
    @user
  end
end
```

You can plug this policy into your pipe at any point. However, this must be inserted after the `:model` is available in operation context, and require current user to be injected into operation.

```ruby
class Create < Trailblazer::Operation
  step Model( Song, :new )
  step Policy::Pundit( MyPolicy, :create? )
  # ...
end

Create.(params, current_user: current_user)
```

---

## `Policy::Pundit` Name

You can add any number of Pundit policies to your pipe. Make sure to use name: to name them, though.

```ruby
class Create < Trailblazer::Operation
  step Model( Song, :new )
  step Policy::Pundit( MyPolicy, :create?, name: "after_model" )
  # ...
end

result = Create.({}, "current_user" => Module)
result["result.policy.after_model"].success? #=> tru
```

---

## `Policy::Pundit` Dependency Injection

Override a configured policy using dependency injection.

You can inject it using "policy.#{name}.eval". It can be any object responding to call.

```ruby
Create.(params: params,
        current_user: current_user,
        "policy.default.eval" => Trailblazer::Operation::Policy::Pundit.build(AnotherPolicy, :create?)
)
```

---

## `Policy::Guard`

A guard is a step that helps you evaluating a condition and writing the result. If the condition was evaluated as falsey, the pipe won’t be further processed and a policy breach is reported in `result["result.policy.default"]`.

Here you have full control of what and how you would like to authorize. Also you could perform authorization on per-operation basis, and not per-resource like Pundit does, and share callable `Guard`'s among operations.
That is a great help when you need different authorization rules for one resource in defferent operations.

--

The Policy::Guard macro helps you inserting your guard logic, guard can be a Callable-marked object, instance method or lambda.


```ruby
class MyGuard
  include Uber::Callable

  def call(current_user:, resource:, **)
    current_user.admin_of?(resource)
  end
end

class Create < Trailblazer::Operation
  step Policy::Guard( MyGuard.new )
  # ...
end
```

```ruby
step Policy::Guard( ->(options, params:, **) { params[:pass] } )
```

```ruby
step Policy::Guard( :pass? )

def pass?(options, params:, **)
  params[:pass]
end
```

---

## `Policy::Guard` Name

The guard name defaults to default and can be set via name:. This allows having multiple guards.

```ruby
class Create < Trailblazer::Operation
  step Policy::Guard( MyGuard, name: 'admin?' )
  # ...
end

result = Create.(params: params, current_user: => Module)
result["result.policy.admin?"].success? #=> tru
```

---

## `Policy::Guard` Dependency Injection

Instead of using the configured guard, you can inject any callable object that returns a `Result` object. Do so by overriding the `policy.#{name}.eval` path when calling the operation.


```ruby
Create.(params: params,
        current_user: current_user,
        "policy.default.eval" => Trailblazer::Operation::Policy::Guard.build(MyGuard))
)
```

---

# The End
