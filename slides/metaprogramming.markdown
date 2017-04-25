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
same name as the message. If it fails to find any such method, it end up with `method_missing` method, where a
NoMethodError exception is raised unless you have provided other behavior for it. The method_missing method is passed
the symbol of the non-existent method, an array of the arguments that were passed in the original call and any block
passed to the original method.

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

```ruby
class MyClass
  def my_method; 'my_method'; end
  alias :m :my_method
end

obj = MyClass.new
obj.my_method # => "my_method"
obj.m         # => "my_method"

class MyClass
  alias_method :m2, :m
end

obj.m2 # => "my_method"
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

---

# Instance variables

`instance_variable_get()`, `instance_variable_set()`, `instance_variable_defined?()`

```ruby
class MyClass
  def initialize(p1, p2)
    @a, @b = p1, p2
  end
end

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

# instance_eval and instance_exec

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
m = object.method(:my_method)
m.call # => 1

unbound = m.unbind
another_object = MyClass2.new(2)
m = unbound.bind(another_object)
m.call # => 2
```

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

```ruby
class String
  def self.inherited(subclass)
    puts "#{self} was inherited by #{subclass}"
  end
end

module M
  def self.included(othermod)
    puts "M was mixed in #{othermod}"
  end

  def self.method_added(method)
    puts "New method: M##{method}"
  end

  def my_method; end
end

class MyString < String
  include M

  def singleton_method_added(method)
    puts "New singleton method: #{method}"
  end

  def method_missing(method, *args, &block)
    puts "not existing method #{method} was called"
  end
end

str = MyString.new
str.yay!

def str.yay_method
end
```

```bash
$ ruby hooks.rb
New method: M#my_method
String was inherited by MyString
M was mixed in MyString
not existing method yay! was called
New singleton method: yay_method
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

## Homework

Please implement your own class `Factory` which will have the same behavior as `Struct` class.

---

# Metakoans

```ruby
# metakoans.rb is an arduous set of exercises designed to stretch
# meta-programming muscle.  the focus is on a single method 'attribute' which
# behaves much like the built-in 'attr', but whose properties require delving
# deep into the depths of meta-ruby.  usage of the 'attribute' method follows
# the general form of
#
#   class C
#     attribute 'a'
#   end
#
#   o = C::new
#   o.a = 42  # setter - sets @a
#   o.a       # getter - gets @a
#   o.a?      # query - true if @a
#
# but reaches much farther than the standard 'attr' method as you will see
# shortly.
#
# your path, should you choose to follow it, is to write a single file
# 'knowledge.rb' implementing all functionality required by the koans below.
# as a student of meta-programming your course will be guided by a guru whose
# wisdom and pithy sayings will assist you on your journey.
#
# a successful student will eventually be able to do this
#
#   harp:~ > ruby metakoans.rb knowledge.rb
#   koan_1 has expanded your awareness
#   koan_2 has expanded your awareness
#   koan_3 has expanded your awareness
#   koan_4 has expanded your awareness
#   koan_5 has expanded your awareness
#   koan_6 has expanded your awareness
#   koan_7 has expanded your awareness
#   koan_8 has expanded your awareness
#   koan_9 has expanded your awareness
#   mountains are again merely mountains
#


module MetaKoans
#
# 'attribute' must provide getter, setter, and query to instances
#
  def koan_1
    c = Class::new {
      attribute 'a'
    }

    o = c::new

    assert{ not o.a? }
    assert{ o.a = 42 }
    assert{ o.a == 42 }
    assert{ o.a? }
  end
#
# 'attribute' must provide getter, setter, and query to classes
#
  def koan_2
    c = Class::new {
      class << self
        attribute 'a'
      end
    }

    assert{ not c.a? }
    assert{ c.a = 42 }
    assert{ c.a == 42 }
    assert{ c.a? }
  end
#
# 'attribute' must provide getter, setter, and query to modules at module
# level
#
  def koan_3
    m = Module::new {
      class << self
        attribute 'a'
      end
    }

    assert{ not m.a? }
    assert{ m.a = 42 }
    assert{ m.a == 42 }
    assert{ m.a? }
  end
#
# 'attribute' must provide getter, setter, and query to modules which operate
# correctly when they are included by or extend objects
#
  def koan_4
    m = Module::new {
      attribute 'a'
    }

    c = Class::new {
      include m
      extend m
    }

    o = c::new

    assert{ not o.a? }
    assert{ o.a = 42 }
    assert{ o.a == 42 }
    assert{ o.a? }

    assert{ not c.a? }
    assert{ c.a = 42 }
    assert{ c.a == 42 }
    assert{ c.a? }
  end
#
# 'attribute' must provide getter, setter, and query to singleton objects
#
  def koan_5
    o = Object::new

    class << o
      attribute 'a'
    end

    assert{ not o.a? }
    assert{ o.a = 42 }
    assert{ o.a == 42 }
    assert{ o.a? }
  end
#
# 'attribute' must provide a method for providing a default value as hash
#
  def koan_6
    c = Class::new {
      attribute 'a' => 42
    }

    o = c::new

    assert{ o.a == 42 }
    assert{ o.a? }
    assert{ (o.a = nil) == nil }
    assert{ not o.a? }
  end
#
# 'attribute' must provide a method for providing a default value as block
# which is evaluated at instance level
#
  def koan_7
    c = Class::new {
      attribute('a'){ fortytwo }
      def fortytwo
        42
      end
    }

    o = c::new

    assert{ o.a == 42 }
    assert{ o.a? }
    assert{ (o.a = nil) == nil }
    assert{ not o.a? }
  end
#
# 'attribute' must provide inheritance of default values at both class and
# instance levels
#
  def koan_8
    b = Class::new {
      class << self
        attribute 'a' => 42
        attribute('b'){ a }
      end
      attribute 'a' => 42
      attribute('b'){ a }
    }

    c = Class::new b

    assert{ c.a == 42 }
    assert{ c.a? }
    assert{ (c.a = nil) == nil }
    assert{ not c.a? }

    o = c::new

    assert{ o.a == 42 }
    assert{ o.a? }
    assert{ (o.a = nil) == nil }
    assert{ not o.a? }
  end
#
# into the void
#
  def koan_9
    b = Class::new {
      class << self
        attribute 'a' => 42
        attribute('b'){ a }
      end
      include Module::new {
        attribute 'a' => 42
        attribute('b'){ a }
      }
    }

    c = Class::new b

    assert{ c.a == 42 }
    assert{ c.a? }
    assert{ c.a = 'forty-two' }
    assert{ c.a == 'forty-two' }
    assert{ b.a == 42 }

    o = c::new

    assert{ o.a == 42 }
    assert{ o.a? }
    assert{ (o.a = nil) == nil }
    assert{ not o.a? }
  end

  def assert()
    bool = yield
    abort "assert{ #{ caller.first[%r/^.*(?=:)/] } } #=> #{ bool.inspect }" unless bool
  end
end


class MetaStudent
  def initialize knowledge
    require knowledge
  end
  def ponder koan
    begin
      send koan
      true
    rescue => e
      STDERR.puts %Q[#{ e.message } (#{ e.class })\n#{ e.backtrace.join 10.chr }]
      false
    end
  end
end


class MetaGuru
  require "singleton"
  include Singleton

  def enlighten student
    student.extend MetaKoans

    koans = student.methods.grep(%r/koan/).sort

    attainment = nil

    koans.each do |koan|
      awakened = student.ponder koan
      if awakened
        puts "#{ koan } has expanded your awareness"
        attainment = koan
      else
        puts "#{ koan } still requires meditation"
        break
      end
    end

    puts(
      case attainment
        when nil
          "mountains are merely mountains"
        when 'koan_1', 'koan_2'
          "learn the rules so you know how to break them properly"
        when 'koan_3', 'koan_4'
          "remember that silence is sometimes the best answer"
        when 'koan_5', 'koan_6'
          "sleep is the best meditation"
        when 'koan_7'
          "when you lose, don't lose the lesson"
        when 'koan_8'
          "things are not what they appear to be: nor are they otherwise"
        else
          "mountains are again merely mountains"
      end
    )
  end
  def self::method_missing m, *a, &b
    instance.send m, *a, &b
  end
end


knowledge = ARGV.shift or abort "#{ $0 } knowledge.rb"
student = MetaStudent::new knowledge
MetaGuru.enlighten student
```

---

# The End
