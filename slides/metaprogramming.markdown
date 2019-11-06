---
layout: slide
title:  Metaprogramming
---

# Metaprogramming in Ruby

---

# Open Classes

In Ruby, classes are never closed: you can always add methods to an existing class. This applies to the classes you
write as well as the standard, built-in classes. All you have to do is open up a class definition for an existing
class, and the new contents you specify will be added to whatever's there.

```ruby
class D
  def x
    'X'
  end
end

class D
  def y
    'Y'
  end
end

d = D.new
d.x # => 'X'
d.y # => 'Y'
```
<!-- .element: class="left width-50" -->

```ruby
3.times do
  class C
    puts 'hello'
  end
end

# => Hello
# => Hello
# => Hello
```
<!-- .element: class="right width-50" -->

---

# Monkey See, Monkey Patch

In Ruby, the term `monkey patch` means any dynamic modification to a class.

```ruby
# Evil example

class Fixnum
  def +(adder)
    self - adder
  end
end

1 + 2 # => -1
      # That is correct, I just turned addition into subtraction
```

Monkey patching is a practice which involves substituting the pillars of an house: if you're not very careful in what
you substitute, the whole building will collapse over your remains. Moreover, you may take down some underground
stations full of people as well as a side-effect.

Carefully check the existing methods in a class before you define your own methods.
Adding a new method is usually safer than modifying an existing one.

---

# Classes

Classes themselves are nothing but objects.

```ruby
'hello'.class          # => String
String.class           # => Class
String.superclass      # => Object
Object.superclass      # => BasicObject
BasicObject.superclass # => nil
Class.superclass       # => Module
Module.superclass      # => Object
```

---

# Calling methods dynamically

The most common way for dynamic method calling is to send a message to object.

```ruby
'hi there'.send(:length) #=> 8
```

A Method object represents a chunk of code and a context in which it executes. Once we have our Method object, we can
execute it sometime later by sending it the message call.

```ruby
method_object = 'hi there'.method(:length)
method_object.call #=> 8
```

Or just eval

```ruby
eval "'hi there'.length" #=> 8
```

Instantiating a method object is the fastest dynamic way in calling a method, eval is the slowest one. Also when
sending a message to an object, or when instantiating a method object, you can call private methods of that object.

---

# Defining methods dynamically

You can define a method on the spot with `define_method()`. You just need to provide a method name and a block, which
becomes the method body.

```ruby
class MyClass
  define_method :triple do |my_arg|
    my_arg * 3
  end
end

obj = MyClass.new
obj.triple(2) # => 6
```

---

# Undefining methods

A method can be undefined any time, as well as defined.

```ruby
class MyClass
  def meth1; 'meth1 called'; end
  def meth2; 'meth2 called'; end
  def meth3; 'meth3 called'; end
end

obj = MyClass.new # => #<MyClass:0x9170850>
obj.meth1         # => "meth1 called"
```

```ruby
class MyClass
  undef meth1
  remove_method :meth2
  undef_method :meth3
end

obj.meth1 # => NoMethodError
obj.meth2 # => NoMethodError
obj.meth3 # => NoMethodError
```

---

# Defining classes dynamically

```ruby
MyClass = Class.new do
  define_method :my_method do
    'Method call'
  end
end

MyClass.new.my_method # => "Method call"
```

---

# Undefining class

As a class is just an object in the memory, which is identified by the constant, destroying a constant will cause a
class itself to be removed by GC

```ruby
Object.send(:remove_const, :MyClass)
obj = MyClass.new # => NameError: unitialized constant
```

---

# Method missing

When you send a message to an object, the object executes the first method it finds on its method lookup path with the
same name as the message. If it fails to find any such method, it end up with `method_missing` method (instance method
of Kernel that every object inherits.), where a NoMethodError exception is raised unless you have provided other
behavior for it. The method_missing method is passed the symbol of the non-existent method, an array of the arguments
that were passed in the original call and any block passed to the original method.

```ruby
class Person
  def method_missing (meth, *args, &block)
    if meth.to_s =~ /^find_all_by_(\w+)$/
      'Looking for the Person'
    else
      super
    end
  end
end
```

---

# Method aliases

You can give an alternate name to a Ruby method by using the `alias` or `alias_method`

In alias, the new name for the method comes first, and the original name comes second.
First difference you will notice is that in case of `alias_method` we need to use a comma between methods.
Also alias_method can takes both symbols and strings as input:

```ruby
alias_method 'new_name', 'original_name'
```

The second difference `alias` and `alias_method` has different scopes.

```ruby
class Test
  def number; 42; end
  def self.add_alias
    alias_method :new_number, :number
    # alias_method 'new_number', 'number'
  end
end

class NewTest < Test
  def number; 100; end
  add_alias
end

NewTest.new.new_number # => 100



class Test
  def number; 42; end
  def self.add_alias
    alias :new_number :number
    # alias new_number number
  end
end

class NewTest < Test
  def number; 100; end
  add_alias
end

NewTest.new.new_number # => 42
```

---

# What happens if you alias a method and then redefine it?

```ruby
class String
  alias :real_length :length

  def length
    real_length > 5 ? 'long' : 'short'
  end
end

'War and Peace'.real_length # => 13
'War and Peace'.length      # => "long"
```

The previous code redefines String#length, but the alias still refers to the original method. When you redefine a
method, you don’t really change the method. Instead, you define a new method and attach an existing name to that new
method. You can still call the old version of the method as long as you have another name that’s still attached to it.

---

# Instance variables

`instance_variable_get()`, `instance_variable_set()`, `instance_variable_defined?()`

```ruby
class MyClass
  def initialize(p1, p2)
    @a, @b = p1, p2
  end
end
```

```ruby
c = MyClass.new('aaa', 'bbb')

puts c.instance_variable_get(:@a)         # => "aaa"
puts c.instance_variable_set(:@a, 'dog')  # => "dog"
puts c.instance_variable_get(:@a)         # => "dog"
puts c.instance_variable_set(:@c, 'cat')  # => "cat"
puts c.instance_variable_defined?(:@c)    # => true
puts c.instance_variable_get(:@c)         # => "cat"
```

---

# Blocks and local variables

```ruby
my_var = 'Success!'

class MyClass
  puts "#{my_var} in class definition"

  def my_method
    puts "#{my_var} in the method"
  end
end

MyClass.new.my_method
# => undefined local variable or method `my_var` for MyClass::Class (NameError)
```

```ruby
my_var = 'Success'

MyClass = Class.new do
  puts "#{my_var} in class definition"

  define_method :my_method do
    puts "#{my_var} in the method"
  end
end

MyClass.new.my_method
# => Success in class definition
# => Success in the method
```

---

# Methods with shared variable

```ruby
def define_methods
  shared = 0

  Kernel.send :define_method, :counter do
    shared
  end

  Kernel.send :define_method, :inc do |x|
    shared += x
  end
end

define_methods
puts counter # => 0
inc(4)
puts counter # => 4
```

---

# Binding

> In Ruby current binding can be captured, and any code can be evaluated in that captured scope, any time.

```ruby
def local_with_binding(bind)
  bind.eval('local')
end

def my_meth
  local = 'local from the inside'
  local_with_binding(binding)
end

local = 'top level local'
puts local_with_binding(binding)  # => "top level local"
puts my_meth                      # => "local from the inside"
```

---

### instance_eval and instance_exec

> `instance_eval` method evaluates a string containing Ruby source code, or the given block, within
the context of the receiver (obj).

```ruby
class MyClass
  def initialize
    @v = 1
  end
end

obj = MyClass.new
obj.instance_eval do
  self # => #<MyClass:0x3340dc @v=1>
  @v   # => 1
end

v=2
obj.instance_eval { @v = v }
obj.instance_eval { @v } # => 2

obj.instance_exec(3) { |multiplier| @v * multiplier } # => 6
```

The `instance_eval` method can only evaluate a block (or a string) but that's it.

But `instance_exec` on the other hand, will evaluate a provide block and allow you to pass arguments.

---

# Class eval

`class_eval` (also known by its alternate name, `module_eval`) evaluates a block in the context of an existing
class.

```ruby
def add_method_to(a_class)
  a_class.class_eval do
    def m
      'Hello!'
    end
  end
end

add_method_to String

'abc'.m # => "Hello!"
```

---

# Method Objects binding

```ruby
class MyClass
  def initialize(value)
    @x = value
  end

  def my_method
    @x
  end
end

class MyClass2 < MyClass
end

object = MyClass.new(1)
method_object = object.method(:my_method)
method_object.call # => 1
```

By calling `Object#method`, you get the method itself as a Method object, which you can later execute with `Method#call`

--

You can detach a method from its object with `Method#unbind`, which returns an UnboundMethod object. You can’t execute
an UnboundMethod, but you can turn it back into a Method by binding it to an object.

```ruby
unbound = method_object.unbind
another_object = MyClass2.new(2)
method_object = unbound.bind(another_object)
method_object.call # => 2
```

This technique works only if another_object has the same class as the method’s original object—otherwise,
you’ll get an exception.

---

# Runtime introspection

```ruby
class MyClass
  def my_method
    @v = 1
    my_private
  end

  private

  def my_private
    caller
  end
end

obj = MyClass.new

def obj.my_singleton
  "i'm singleton"
end

obj.my_method                           # => ["test.rb:4:in `my_method`",
                                        # "test.rb:16:in `<top>`", ... ]
obj.class                               # => MyClass
obj.methods.grep /my/                   # => [:my_singleton, :my_method]
obj.private_methods.grep /my/           # => [:my_private]
obj.instance_variables                  # => [:@v]
obj.singleton_methods                   # => [:my_singleton]

MyClass.instance_methods(false)         # => [:my_method]
local_variables                         # => [:obj]

MyClass.instance_methods == obj.methods # => false, should be true but we have 'my_singleton' method
MyClass.methods == obj.methods          # => false
```

---

## Hook methods

The `inherited` method is an instance method of Class, and Ruby calls it when a class is inherited. By default,
`Class#inherited` does nothing, but you can override it with your own code.

inherited_hook.rb <!-- .element: class="filename" -->

```ruby
class String
  def self.inherited(subclass)
    puts "#{self} was inherited by #{subclass}"
  end
end

class MyString < String
end
```

```bash
$ ruby inherited_hook.rb
String was inherited by MyString
```

--

Just as you override `Class#inherited` to plug into the life cycle of classes, you can plug into the life cycle of
modules by overriding `Module#included`:

included_hook.rb <!-- .element: class="filename" -->

```ruby
module M
  def self.included(othermod)
    puts "M was mixed into #{othermod}"
  end
end

class C
  include M
end
```

```bash
$ ruby included_hook.rb
M was mixed into C
```

You can also execute code when a module extends an object by overriding Module#extend_object.

--

#### You can execute method-related events by overriding
`Module#method_added`, `singleton_method_added`, or `method_missing`.

hooks.rb <!-- .element: class="filename" -->

```ruby
module M
  def self.method_added(method)
    puts "New method: M##{method}"
  end

  def my_method
  end
end

class MyString < String
  include M

  def singleton_method_added(method)
    puts "New singleton method: #{method}"
  end
end

str = MyString.new

def str.yay_method
end
```

```bash
$ ruby hooks.rb
New method: M#my_method
New singleton method: yay_method
```

--

## Overriding method_missing

Most likely, you will never need to call `method_missing` yourself.
Instead, you can override it to intercept unknown messages. Each
message landing on `method_missing` desk includes the name of the
method that was called, plus any arguments and blocks associated with
the call.

override_method_missing.rb <!-- .element: class="filename" -->

```ruby
class Lawyer
  def method_missing(method, *args)
    puts "You called: #{method}(#{args.join(', ')})"
    puts "(You also passed it a block)" if block_given?
  end
end

bob = Lawyer.new
bob.talk_simple('a', 'b') do
  # a block
end
```

```bash
$ ruby override_method_missing.rb
You called: talk_simple(a, b)
(You also passed it a block)
```

---

# Class plus instance methods

```ruby
module MyMixin
  def self.included(base)
    base.extend ClassMethods
  end

  def x
    'x()'
  end

  module ClassMethods
    def y
      'y()'
    end
  end
end

class C
  include MyMixin
end

C.new.x # => x()
C.y     # => y()

```

---

# Struct

Follow by http://www.ruby-doc.org/core-2.3.1/Struct.html for more information.

```ruby
Customer = Struct.new(:name, :address, :zip)
# => Customer

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
# => #<struct Customer name="Joe Smith", address="123 Maple, Anytown NC", zip=12345>

joe.name    # => "Joe Smith"
joe['name'] # => "Joe Smith"
joe[:name]  # => "Joe Smith"
joe[0]      # => "Joe Smith"
```

```ruby
Customer = Struct.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

Customer.new('Dave', '123 Main').greeting # => "Hello Dave!"
```

---

# Control questions

- What is open classes principes?
- What for monkey patching? Is it good?
- When do need to use dynamic declaration of classes/methods?
- `alias_method` and `alias`, what difference?
- `instance_eval` and `class_eval`, what difference?
- What is Struct?

---

## Homework

Please implement your own class `Factory` which will have the same behavior as `Struct` class.

```bash
$ git clone https://github.com/dzemlianoi-double/ruby-factory
$ cd ruby-factory
$ bundle
$ rspec .
```

Your Factory must be implemented at `lib/factory.rb`.
There you will also find detailed task info.

---

# The End
