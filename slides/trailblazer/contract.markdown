---
layout: slide
title: Operation Contract
---

# Operation `Contract`

---

## Contract

A contract is an abstraction to handle validation of arbitrary data or object state. It is a fully self-contained object that is orchestrated by the operation.

The actual validation can be implemented using Reform with `ActiveModel::Validation` or `dry-validation`, or a `Dry::Schema` directly without Reform.

The Contract macros helps you defining contracts and assists with instantiating and validating data with those contracts at runtime.

--

## Contract usage

Using contracts consists of five steps:

1. Define the contract class (or multiple of them) for the operation.
2. Plug the contract creation into the operation’s pipe using Contract::Build.
3. Run the contract’s validation for the params using Contract::Validate.
4. If successful, write the sane data to the model(s). This will usually happen in the Contract::Persist macro.
5. After the operation has been run, interpret the result. For instance, a controller calling an operation will render a erroring form for invalid input.

---

## Reform

Most contracts are `Reform` objects that you can define and validate in the operation. `Reform` is a fantastic tool for deserializing and validating deeply nested hashes, and then, when valid, writing those to the database using your persistence layer such as `ActiveRecord`.

Reform coerces and validates data, and writes it to the model.
A model can be any kind of Ruby object. Reform is completely framework-agnostic and doesn’t care about your database.

Form fields are specified using `property` and `collection`, validations for the fields using the respective validation engine’s API.
Forms can also be nested and map to more complex object graphs.


```ruby
class AlbumForm < Reform::Form
  property :title

  # dry-rb validations
  validation do
   required(:title).filled
  end
  # or with ActiveModel validations:
  # validates :title, presence: true

  property :artist do
    property :name

    validation do
     required(:name).filled
    end
  end
end
```
--

### Virtual attributes

Often, fields like `password_confirmation` should neither be read from nor written back to the model. Reform comes with the :virtual option to handle that case.

```ruby
class PasswordForm < Reform::Form
  property :password
  property :password_confirmation, virtual: true
```

--

### Validation groups

Validation in Reform happens in the `validate` method, and only there.
It returns the result boolean, and provide potential errors via errors.
It creates validation group, that provides the exact same API as a `Dry::Validation::Schema`,

`validation` expects `name` of validation group as first argument and hash of `options`.
Grouping validations enables you to run them conditionally, or in a specific order. You can use `:if` to specify what group had to be successful for it to be validated.

```ruby
validation :default do
  required(:title).filled
end

validation :unique, if: :default do
  configure do
    def unique?(value)
      # ..
    end
  end

  required(:title, &:unique?)
end
```

--

`:if` option can also receive proc

```ruby
validation :shipping_address, if: proc { model.shippable? } do
  optional(:shipping_address_id).maybe(:int?)
end
```

Chaining groups works via the `:after` option. This will run the group regardless of the former result. Note that it still can be combined with `:if`.

--

At any time you can extend an existing group using :inherit. This appends validations to the existing :email group.

```ruby
validation :email, inherit: true do
  required(:email).filled
end
```

--

Custom predicates have to be defined in the validation group.

If you need access to your form, you need to specifify `option :form` in `configure` block of validation schema
```ruby
validation :default do
  configure do
    option :form

    def unique?(value)
      Album.where.not(id: form.model.id).where(title: value).empty?
    end
  end

  required(:title).filled(:unique?)
end
```

In versions prior to 2.2.4, you also must pass `with: {form: true}` to your validation block to achieve this

```ruby
validation :default, with: {form: true} do
  configure do
    option :form
    ...
  end
  ...
end
```

--

## Collections

Collections can be defined analogue to `property`.

```ruby
class AlbumForm < Reform::Form
  collection :song_titles
end
```

--

### More on Reform: http://trailblazer.to/gems/reform/index.html

---

## Dry-rb validations

It is based on the idea that each validation is encapsulated by a simple, stateless predicate that receives some input and returns either `true` or `false`. Those predicates are encapsulated by `rules` which can be composed together using predicate logic.

Here the predicates `none?` and `int?` conjuncted into validation rule
```ruby
required(:age) { none? | int? }
```

--

### Macros

Rule composition using blocks is very flexible and powerful; however, in many common cases repeatedly defining the same rules leads to boilerplate code. That’s why dry-validation’s DSL provides convenient macros to reduce that boilerplate. Every macro can be expanded to its block-based equivalent.

```ruby
Dry::Validation.Schema do
  # expands to `required(:age) { filled? & int? }`
  required(:age).filled(:int?)
end

Dry::Validation.Schema do
  # expands to `required(:age) { none?.not > int? }`
  required(:age).maybe(:int?)
end
```

--

### Custom predicates

You can simply define predicate methods on your schema object:

```ruby
schema = Dry::Validation.Schema do
  configure do
    def email?(value)
      ! /magical-regex-that-matches-emails/.match(value).nil?
    end
  end

  required(:email).filled(:str?, :email?)
end
```

--

Or re-use a predicate container across multiple schemas:

```ruby
module MyPredicates
  include Dry::Logic::Predicates

  predicate(:email?) do |value|
    ! /magical-regex-that-matches-emails/.match(value).nil?
  end
end

schema = Dry::Validation.Schema do
  configure do
    predicates(MyPredicates)
  end

  required(:email).filled(:str?, :email?)
end
```

You need to provide error messages for your custom predicates if you want them to work with Schema#call(input).messages interface.

```ruby
configure do
  config.messages = :i18n
  config.namespace = :namespace_name
end
```

--

## Custom Validation Blocks

Custom validation blocks are executed only when the values they depend on are valid. You can define these blocks using `validate` DSL, they will be executed in the context of your schema objects, which means schema collaborators or external configurations are accessible within these blocks

```ruby
# inside reform validation block with forwarded form object
validation :default, with: { form: true } do
  configure do
    config.messages = :i18n
    config.namespace = :order_cancellation

    option :form
  end

  required(:total).filled(:decimal?, gteq?: 0.0)
  required(:reason).filled(:str?)

  validate(correct_total?: [:total]) do |total|
    total <= form.model.order.total
  end
end
```

--

## High-level Rules

It's possible to specify higher-level rules that rely on other rules. This can be achieved using the `rule` interface which can access already defined rules for specific keys.

```ruby
schema = Dry::Validation.Schema do
  required(:login).maybe(:str?)
  required(:email).maybe(:str?)

  rule(email_presence: [:login, :email]) do |login, email|
    login.none? > email.filled?
  end
end
```

When the validity of one attribute depends on the value of another attribute, you can use `value`:

```ruby
schema = Dry::Validation.Schema do
  required(:started).filled(:date?)
  required(:ended).filled(:date?)

  rule(started_before_ended: [:started, :ended]) do |started, ended|
    ended.gt?(value(:started))
  end
end
```


--

### More on dry-rb validations https://dry-rb.org/gems/dry-validation/

---

## Contract Definition

#### Explicit

```ruby
module Registrations
  module Contracts
    class Create < Reform::Form
      include Dry

      property :full_name
      property :email
      property :password, virtual: true
      property :password_confirmation, virtual: true


      validation :default do
        required(:full_name).filled(:str?)
        required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
        required(:password).filled(
          :str?,
          min_size?: Constants::Shared::PASSWORD_MIN_LENGTH,
          format?: Constants::Shared::PASSWORD_REGEX
        ).confirmation
      end
    end
  end

  module Operations
    class Create < Trailblazer::Operation
      step Model( User, :new )
      step Contract::Build(constant: Registrations::Contracts::Create)
      step Contract::Validate()
      step Contract::Persist()
    end
  end
end
```

--

#### Inline

Don't do this

```ruby
class Registrations::Operations::Create < Trailblazer::Operation
  extend Contract::DSL

  contract do
    property :full_name
    property :email

    # ...
  end

  step Model(User, :new)
  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()
end
```

---

## Nesting

To create forms for nested objects, both property and collection accept a block for the nested form definition.
Nesting will simply create an anonymous, nested Reform::Form class for the nested property.

It’s often helpful with has_many or belongs_to associations.

```ruby
class AlbumForm < Reform::Form
  property :artist do
    property :name
  end

  collection :songs do
    property :title
  end

  validation :default do
    required(:artist) do
      required(:name).filled(:str?)
    end

    required(:songs).each do
      required(:title).filled(:str?)
    end
  end
end
```

<?--
--

## Validating collection

When validating collection with custom predicate, you could use `:array?` predicate to avoid perfomance issues (dry-validation will check if field is a string by default, and if it isn't it would `.inspect` array of nested forms).

```ruby
class Post::Create < Reform::Form
  collection :comments, form: Comment::Create

  validation do
    configure do
      option :form

      def custom_predicate
        ...
      end
    end

    required(:comments).filled(:array?, :custom_predicate)
  end
end
```

--

## Disposable::Twin::Parent

`feature Disposable::Twin::Parent` allows you to access parent in nested forms.

You would need to add `require 'disposable/twin/parent'` to your trailblazer initializer file `config/initializers/trailblazer.rb`

```ruby
class AlbumForm < Reform::Form
  feature Disposable::Twin::Parent

  property :artist_name

  collection :songs do
    property :title, default: :default_title

    def default_title
      "#{parent.artist_name} - Unknown Track"
    end
  end
end
```

--

## Types and Coercion

To coerce your input you can use [dry-rb types](https://github.com/dry-rb/dry-types).
Disposable already defines a module `Disposable::Twin::Coercion::Types` with all the `Dry::Types` built-in types. So you can use any of the [documented types](https://dry-rb.org/gems/dry-types/built-in-types/).

You would need to add `require 'reform/form/coercion'` to your trailblazer initializer file `config/initializers/trailblazer.rb`

```ruby
class Create < Reform::Form
  include Dry
  feature Coercion

  property :id, type: Types::Form::Int
end
```

Coercion also supports the conversion of blank strings ("") into nil. This is known as nilify and provided via the :nilify option.

```ruby
property :id, type: Types::Form::Int, nilify: true
```

--

## Skip Parsing

To avoid parsing of property you can use `:skip_parse`. The property will be still mapped on model.

```ruby
property :uuid, skip_parse: true
```

--

## Default values

Default values can be set via `:default`.
Default value is applied when the model’s getter returns nil when initializing the contract.
`:default` works with `:virtual` and `readable: false`. Can also be a lambda

```ruby
class Album::Contract::Create < Reform::Form
  property :name
  property :title, default: "The Greatest Songs Ever Written"
  property :composer
    property :id
    property :name, default: -> { "Object-#{id}" }
  end
end
```

`:default` could also receive a method symbol.

```ruby
class Album::Contract::Create < Reform::Form
  property :composer do
    property :id
    property :name, default: :captured_payment
  end

  def captured_payment
    "Object-#{id}"
  end
end
```

---

## Populators

`populate_if_empty`
When you have nested form, reform had to instantiate it to perform validation. But Reform per design makes no assumptions about how to create nested models. So you have to tell it what to do in this out-of-sync case.

To let Reform create a new model wrapped by a nested form in case of its absence, use `:populate_if_empty`.

It receives the class to be instantiated.

```ruby
class AlbumForm < Reform::Form
  collection :songs, populate_if_empty: Song do
    property :name
  end
end
```

Or lambda

```ruby
  property :shipping_address, populate_if_empty: ->(_) { Address.shipping.new(addressable: model) }
```

--

### `populator`

While the `:populate_if_empty` option is only called when no matching form was found for the input, the `:populator` option is always invoked and gives you maximum flexibility for population. They’re exclusive, you can only use one of the two.

A `:populator` for collections is executed for every collection fragment in the incoming hash

```ruby
class AlbumForm < Reform::Form
  collection :songs,
    populator: -> (collection:, index:, **) do
      if item = collection[index]
        item # instance of Reform::Form
      else
        collection.append(Song.new) # collection exposes Enumerable interface, and automatically wraps model in Reform::Form
      end
    end
end
```

It is very important that each `:populator` invocation returns the form that represents the fragment, and not the model. Otherwise, deserialization will fail.

--

### Single Property `populator`

Naturally, a :populator for a single property is only called once.

```ruby
class AlbumForm < Reform::Form
  property :composer,
    populator: -> (model:, **) do
      model || self.composer= Artist.new
    end
end
```

A single populator works identical to a collection one, except for the `model` argument, which is equal to `self.composer`

--

### `populator` Id Matching

Per default, Reform matches incoming hash fragments (available as `fragment:` in kw-args) and nested forms by their order. It doesn’t know anything about IDs, UUIDs or other persistence mechanics.

You can use :populator to write your own matching for IDs.

```ruby
collection :songs,
  populator: ->(fragment:, **) {
    # find out if incoming song is already added.
    item = songs.find { |song| song.id == fragment["id"].to_i }

    item ? item : songs.append(Song.new)
  }
```

--

### Delete in `populator`

Populators can not only create, but also destroy.

You can delete items from the graph using `delete`. To avoid this fragment being further deserialized, use `return skip!` to stop processing for this fragment.

```ruby
collection :songs,
  populator: ->(fragment:, **) {
    # find out if incoming song is already added.
    item = songs.find { |song| song.id.to_s == fragment["id"].to_s }

    if item
      songs.delete(item)
      return skip!
    end

    songs.append(Song.new)
  }
```

---

## `Build` macro

The Contract::Build macro helps you to instantiate the contract. It is both helpful for a complete workflow, or to create the contract, only, without validating it, e.g. when presenting the form.

This macro will grab the model from `ctx["model"]` and pass it into the contract’s constructor. The contract is then saved in `ctx["contract.default"]`.
The `Build` macro accepts the `:name` option to change the name from default.

```ruby
class Create < Trailblazer::Operation
  step Model(User, :new)
  step Contract::Build(constant: Registrations::Contracts::Create)
  # ...
end
```

--

### Manual Build

To manually build the contract instance (e.g. to inject the current user), use `builder:` with any callable.

```ruby
class Comments::Contracts::Create < Reform::Form
  include Dry

  property :body
  property :current_user, virtual: true

  validation :default do
    required(:body).filled(:str?)
    # ... validations with current_user
  end
end

class Comments::Operations::Create < Trailblazer::Operation
  step Model( Comments, :new )
  step Contract::Build( builder: :build_contract )
  step Contract::Validate()
  step Contract::Persist()

  def build_contract(ctx, model:, current_user:, **)
    Comments::Contracts::Create.new(model, current_user: current_user)
  end
end
```

---

## `Validate` macro

The `Contract::Validate` macro is responsible for validating the incoming params against its contract. That means you have to use `Contract::Build` beforehand, or create the contract yourself. The macro will then grab the params and throw them into the contract’s `validate` (or `call`) method.
Validate only parses your params and validates the contract, nothing is written to the model, yet.

Depending on the outcome of the validation, it either stays on the right track or deviates to left, skipping the remaining steps.

```ruby
class Create < Trailblazer::Operation
  step Model(User, :new)
  step Contract::Build(constant: Registrations::Contracts::Create)
  step Contract::Validate()
  # ...
end
```

Per default, Contract::Validate will use `options["params"]` as the data to be validated. Use the `key:` option if you want to validate a nested hash from the original params structure. If that key isn’t present in the params hash, the operation fails before the actual validation.

```ruby
class Create < Trailblazer::Operation
  # ...
  step Contract::Validate(key: :user)
  # ...
end
```

---

### `Persist` macro

To push validated data from the contract to the model(s), use Persist. Like Validate, this requires a contract to be set up beforehand.
After the step, the contract’s attribute values are written to the model, and the contract will call save on the model.

```ruby
class Create < Trailblazer::Operation
  step Model(User, :new)
  step Contract::Build(constant: Registrations::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
```

You can also configure the `Persist` step to call `sync` instead of Reform’s `save`.

```ruby
step Persist( method: :sync )
```

---

### Named Contract

For explicit naming you have to use the `name:` option to tell each step what contract to use. The contract and its result will now use your name instead of `default`.

```ruby
class User::Operation::Create < Trailblazer::Operation
  step Model( User, :new )
  step Contract::Build(    name: "form", constant: User::Contract::Create )
  step Contract::Validate( name: "form" )
  step Contract::Persist(  name: "form" )
end
```
Contract in runtime and contract result would be stored under corresponding name:

```ruby
result = User::Operation::Create.({ title: "A" })
result["contract.form"].errors.messages # => {:title=>["is too short (minimum is 2 ch...
# or in result
result["result.contract.form"].success?        #=> false
result["result.contract.form"].errors          #=> Errors object
result["result.contract.form"].errors.messages #=> {:length=>["is not a number"]}
```

---

### Dependency Injection

In fact, the operation doesn’t need any reference to a contract class at all. The contract can be injected when calling the operation - you have to provide the default contract class as a dependency.

```ruby
User::Operation::Create.(params: params, "contract.default.class" => User::Contract::Create)
```

---

# The End
