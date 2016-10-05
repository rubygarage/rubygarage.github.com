---
layout: slide
title:  Object-oriented programming
---

# Object-oriented programming

> Object-oriented programming (OOP) is a programming paradigm that represents the concept of "objects" that have
data fields (attributes that describe the object) and associated procedures known as methods. Objects, which are
usually instances of classes, are used to interact with one another to design applications and computer programs.

<br>

[Go to Table of Contents](/)

---

# Object-oriented programming

> A method call in Ruby is actually the sending of a message to a receiver. When you write `obj.meth`, you're sending
the `meth` message to the object `obj`. `obj` will respond to `meth` if there is a method body defined for it.

![](/assets/images/player_class.png)

---

# Defining a simple class

## Creating the class

```ruby
class BookInStock
end
```

## Define ruby objects

```ruby
book = BookInStock.new
book.class # => BookInStock
book.is_a? BookInStock # => true # this method return true if object is an instance a subclass
book.kind_of? BookInStock # => true  # this method return true if object is an instance a subclass
book.instance_of? BookInStock # => true
```

---

# Defining a simple class

## Initializing the class

```ruby
class BookInStock
  def initialize(title, author, price)
    @title = title
    @author = author
    @price = Float(price)
  end
end

BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
```

---

# Defining a `to_s` method

```ruby
class BookInStock
  def initialize(title, author, price)
    @title = title
    @author = author
    @price = Float(price)
  end

  def to_s
    "Book: #{@title} / #{@author}, #{@price}"
  end
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)

book.to_s # => Book: The Great Gatsby / F. Scott Fitzgerald, 8.99
```

---

# Creating methods for set and get attributes

```ruby
class BookInStock
  def initialize(title, author, price)
    @title = title
    @author = author
    @price = Float(price)
  end

  def title
    @title
  end

  def title=(value)
    @title = value
  end
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)

book.title                           # => The Great Gatsby
book.title = 'This Side of Paradise'
book.title                           # => This Side of Paradise
book.price                           # => NoMethodError: undefned method `price'
book.price = 10                      # => NoMethodError: undefined method `price='
```

---

# Accessor and attributes

```ruby
class BookInStock
  attr_accessor :title
  attr_writer :author
  attr_reader :price

  def initialize(title, author, price)
    @title = title
    @author = author
    @price = Float(price)
  end
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)

book.title = 'This Side of Paradise'
book.title                           # => This Side of Paradise
book.author = 'Fitzgerald'
book.author                          # => NoMethodError: undefined method 'author'
book.price                           # => 8.99
book.price = 10                      # => NoMethodError: undefined method 'price='
```

---

# Virtual attributes

```ruby
class BookInStock
  attr_reader :title, :author, :price

  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
  end

  def price_in_cents
    Integer(@price * 100 + 0.5)
  end

  def price_in_cents=(value)
    @price = value / 100.0
  end
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)

book.price_in_cents = 100
book.price                # => 1.0
book.price_in_cents       # => 100
```

---

# Defining operators

```ruby
class BookInStock
  attr_reader :title, :author, :price

  def initialize(title, author, price)
    @title = title
    @author = author
    @price = Float(price)
  end

  def +(other)
    BookInStock.new("#{@title}, #{other.title}", "#{@author} and #{other.author}", @price+other.price)
  end
end

fitzgerald_book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
hemingway_book = BookInStock.new('The Old Man and the Sea ', 'Ernest Hemingway', 7.6)

books_collection = fitzgerald_book + hemingway_book

books_collection.title  # => The Great Gatsby, The Old Man and the Sea
books_collection.author # => F. Scott Fitzgerald and Ernest Hemingway
books_collection.price  # => 16.59
```

---

# Objects comparison

```ruby
book1 = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
# => BookInStock:0x00000000e71cb0

book2 = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
# => BookInStock:0x00000000e553f8

book1 == book2
# => false
```

---

# Define equality method

```ruby
class BookInStock
  attr_reader :title, :author, :price

  def initialize(title, author, price)
    @title = title
    @author = author
    @price = Float(price)
  end

  def ==(other)
    if other.is_a? BookInStock
      @title == other.title && @author == other.author && @price == other.price
    else
      false
    end
  end
end

book1 == book2 # => true
```

---

# Self in Ruby

> The keyword `self` in Ruby gives you access to the current object – the object that is receiving the current message.

## Self in instance method definitions

> At the time the method definition is executed, the most you can say is that self inside this method will be some future
object that has access to this method.

```ruby
class S
  def m
    self
  end
end

s = S.new

s.m # => <S:0x007ff4fa038a58>
```

---

# Self

```ruby
class BookInStock
  attr_reader :title, :author, :price

  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
  end

  def title
    "Author: #{@author}"
  end

  def my_object_print
    puts self.inspect  # => <BookInStock:0x000000010aaef0 @title="t1", @author="a1", @price=10.0>
  end

  def attribute_print
    puts self.author   # => The Great Gatsby
    puts @author       # => The Great Gatsby
  end

  def variable_and_method
    puts title         # => Author: F. Scott Fitzgerald
    title = 'My best title'
    puts title         # => My best title
    puts self.title    # => Author: F. Scott Fitzgerald
  end

  def my_object_as_param
    str = "my string"
    puts str.eql? self # => false
  end

  def method_to_class
    # puts class - error it try to create new class
    puts self.class.inspect     # => BookInStock
    self.class.my_class_method  # => BookInStock
  end

  def self.my_class_print
    puts self.inspect           # => BookInStock
  end
end
```

---

# Class method

```ruby
class BookInStock
  attr_reader :title, :author, :price

  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
  end

  def self.total_amount(*books)
    books.map(&:price).inject(0, &:+)
  end
end

book1 = BookInStock.new('t1', 'a1', 10)
book2 = BookInStock.new('t2', 'a2', 20)

BookInStock.total_amount(book1, book2) # => 30.0
```

```ruby
class BookInStock
  class << self
    def total_amount(*books)
      #code
    end

    def another
      #code
    end
  end
end
```

---

# Class variables

```ruby
class BookInStock
  attr_reader :title, :author, :price

  @@count = 0

  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
    @@count += 1
  end

  def self.statistics
    "Count of books: " + @@count.to_s
  end
end

5.times{ BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99) }

BookInStock.statistics # => Count of books: 5

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)

book.count # => NoMethodError: undefined method 'count'
```

---

# Class instance variables

```ruby
class BookInStock
  attr_reader :title, :author, :price

  @count = 0

  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
    # @count += 1  NoMethodError: undefined method '+' for nil:NilClass
  end

  def self.add
    @count += 1
  end

  def self.statistics
    'Count of add method call: ' + @count.to_s
  end
end

BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)

5.times{ BookInStock.add }

BookInStock.statistics # => Count of add method call: 5
```

---

# Class constants

```ruby
class BookInStock
  PUBLISHING = 'Book House'
end

BookInStock::PUBLISHING     # => Books House

BookInStock::MIN_PRICE = 10
BookInStock::MIN_PRICE      # => 10
BookInStock::MIN_PRICE = 20 # => warning: already initialized constant BookInStock::MIN_PRICE
BookInStock::MIN_PRICE      # => 20
```

---

# Scope

```ruby
v1 = 1

class MyClass
  v2 = 2

  local_variables   # => [:v2]

  def my_method
    v3 = 3
    local_variables
  end

  local_variables   # => [:v2]
end

obj = MyClass.new

obj.my_method       # => [:v3]

local_variables     # => [:v1, :obj]
```

---

# Method visibility

```ruby
class BookInStock
  attr_reader :title, :author, :price

  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
  end

  def buy_with(other)
    discount + other.discount # self.discount + other.discount
  end

  def full_cost
    @price + tax
    # self.tax  # => NoMethodError: private method 'tax' called
  end

  def tax_for_two(other) # error
    tax + other.tax      # you can user private method only for self
  end

  protected

  def discount
    @price * 0.9
  end

  private

  def tax
    @price * 0.2
  end
end

fitzgerald_book  = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
hemigway_book = BookInStock.new('The Old Man and the Sea', 'Ernest Hemingway', 7.6)

fitzgerald_book.buy_with hemigway_book    # => 14.93
fitzgerald_book.full_cost                 # => 10.78
fitzgerald_book.discount                  # => NoMethodError: protected method 'discount' called
fitzgerald_book.tax_for_two hemigway_book # => NoMethodError: private method 'tax' called
```

---

# Inheritance

```ruby
class PrintPublication
  def initialize(title, author)
    @title, @author = title, author
  end
end

class BookInStock < PrintPublication
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald')
# => <BookInStock:0x00000000f2c538 @title="The Great Gatsby", @author="F. Scott Fitzgerald">

BookInStock.superclass # => PrintPublication
```

---

# Methods inheritance

```ruby
class PrintPublication
  def initialize(title, author)
    @title, @author = title, author
  end

  def public_method
    "public method called"
  end

  def call_protected_method
    my_protected_method
  end

  def call_private_method
    my_private_method
  end

  protected

  def my_protected_method
    "protected method called"
  end

  private

  def my_private_method
    "private method called"
  end
end

class BookInStock < PrintPublication
  def call_private_and_protected
    my_protected_method + my_private_method
  end
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald')

book.public_method              # => "public method called"
book.call_protected_method      # => "protected method called"
book.call_private_method        # => "private method called"
book.call_private_and_protected # => "protected method calledprivate method called"
```

---

# Method super

```ruby
class PrintPublication
  def initialize(title, author)
    @title, @author = title, author
  end
end

class BookInStock < PrintPublication
  def initialize(title, author, price)
    @price = price
    super(title, author)
  end
end

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
# => #<BookInStock:0x000000024f2408 @price=8.99, @title="The Great Gatsby", @author="F. Scott Fitzgerald">
```

```ruby
class BookInStock < PrintPublication
  def initialize(title, author, price)
    @price = price
    super # => ArgumentError: wrong number of arguments (3 for 2)
  end
end
```

---

# Inheritance class variables

```ruby
class A
  @@value = 1

  def self.value
    @@value
  end
end

A.value # => 1

class B < A
  @@value = 2
end

class C < A
  @@value = 3
end

B.value # => 3
```

---

# Class constants inheritance

```ruby
class A
  NUM = 2
end

class B < A
end

A::NUM     # => 2
B::NUM     # => 2
B::NUM = 3
A::NUM     # => 2
B::NUM     # => 3
```

---

# Class hierarchy

![](/assets/images/class-hierarchy.dot.svg)

---

# Class as object

```ruby
BookInStock = Class.new do
  def initialize(title, author, price)
    @title, @author, @price = title, author, Float(price)
  end

  attr_reader :title, :author, :price

  def cover
    "#{@title}, #{@author}"
  end
end

BookInStock       # => BookInStock
BookInStock.class # => Class

book = BookInStock.new('The Great Gatsby', 'F. Scott Fitzgerald', 8.99)
book.cover # => "The Great Gatsby, F. Scott Fitzgerald"
```

---

# Singleton methods and eigenclass

## Ways to create singleton methods

```ruby
class BookInStock
  def BookInStock.sum
  end
end

class BookInStock
  class << self
    def sum
    end
  end
end

class << BookInStock
  def sum
  end
end
```

---

# Singleton methods and eigenclass

## Ways to add a custom behaviour to an instance

```ruby
book = BookInStock.new

def book.title
  'Title'
end

book.title # => Title

class << book
  def title
    'Title'
  end
end

book.title                # => Title
another = BookInStock.new
another.title             # => NoMethodError: undefined method 'title'
```

---

# Module

```ruby
module AudioConverter
  class Decoder
    def initialize file
      @file, @format = @file, AudioHelpers.get_format(file)
    end
  end

  class Encoder
    def initialize file
      @file, @format = @file, AudioHelpers.get_format(file)
    end
  end

  class AudioHelpers
    def self.get_format file
      File.extname(file)
    end
  end
end

AudioConverter::Decoder.new('music.mp3')
```

---

# Module constants, paths

```ruby
module M
  class C
    X = 'a constant'
  end

  C::X  # => "a constant"
end

M::C::X # => "a constant"

module M
  Y = 'another constant'

  class C
    ::M::Y # => "another constant"
  end
end

M.constants # => [:C, :Y]

module M
  class C
    module M2
      Module.nesting # => [M::C::M2, M::C, M]
    end
  end
end
```

---

# Mixins

```ruby
module AudioConverter
  def compare_formats another_file
    File.extname(@file) == File.extname(another_file)
  end
end

class AudioUpload
  include AudioConverter

  def initialize(file)
    @file = file
  end
end

audio_upload = AudioUpload.new('music.mp3')
audio_upload.compare_formats('video.avi')
```

--

# require

```ruby
require 'audio_converter'

class AudioUpload
  include AudioConverter

  def initialize(file)
    @file = file
  end
end
```

---

# Extend with module

```ruby
module AudioConverter
  def formats
    ['mp3', 'avi', 'ogg']
  end
end

class AudioUpload
  extend AudioConverter

  # class << self
  #   include AudioConverter
  # end

  def initialize(file)
    @file = file
  end
end

AudioUpload.formats # => ["mp3", "avi", "ogg"]

audio = AudioUpload.new('audio.mp3')
audio.formats # => NoMethodError: undefined method 'formats'
audio.extend(AudioConverter)
audio.formats # => ["mp3", "avi", "ogg"]
```

---

# Class and modules hierarchy, ancestors

```ruby
module M
end

class C
  include M
end

class D < C
end

D.ancestors # => [D, C, M, Object, Kernel, BasicObject]
```
<!-- .element class="left width-70" -->

![](/assets/images/modules-hierarchy.dot.svg)
<!-- .element class="right width-20" -->

---

# Method lookup

- Сhecks the eigenclass of `foo` for singleton methods named `bar`.

- If no method `bar` is found in the eigenclass, Ruby searches the class of `foo` for an instance method named `bar`.

- If no method `bar` is found in the class, Ruby searches the instance methods of any modules included by the class of
  `foo`. If that class includes more than one module, then they are searched in the reverse of the order in which they
  were included. That is, the most recently included module is searched first.

- If no instance method `bar` is found in the class of `foo` or in its modules, then the search moves up the
  inheritance hierarchy to the superclass. Steps 2 and 3 are repeated for each class in the inheritance hierarchy until
  each ancestor class and its included modules have been searched.

- If no method named `bar` is found after completing the search, then a method named `method_missing` is invoked instead.

```ruby
foo = 'some string'
foo.bar # singleton: no -> String class: no -> Comparable module: no ->
        # Object class: no -> Kernel module: no -> method_missing: no -> raise an exception
```

---

# Exceptions

--

# begin, rescue, raise

```ruby
begin
  puts 'I am before the raise.'
  raise 'An error has occured.'
  puts 'I am after the raise.'
rescue
  puts 'I am rescued.'
end

puts 'I am after the begin block.'

# I am before the raise.
# I am rescued.
# I am after the begin block.
```

--

# Exception type, else, ensure

```ruby
begin
  raise 'A test exception.'
rescue Exception => e
  puts e.message
  puts e.backtrace.inspect
ensure
  puts 'Ensuring execution'
end

# A test exception.
# ["test.rb:2:in '<main>'"]
# Ensuring execution
```

```ruby
begin
  puts 'A test exception.'
rescue Exception => e
  puts e.message
  puts e.backtrace.inspect
else
  puts 'Executes if there is no exeception'
ensure
  puts 'Ensuring execution'
end

# A test exception.
# Executes if there is no exception
# Ensuring execution
```

--

# Throw and catch

```ruby
def try_throw_if(act)
  puts "Try '#{act}'"
  throw :alarm! if act == 'Go! go! go!'
  act
end

catch :alarm! do
  puts try_throw_if('Makes one')
  puts try_throw_if('Makes two')
  puts try_throw_if('Go! go! go!')
  puts try_throw_if('Makes three')
end

puts try_throw_if('Makes four')

# Try 'Makes one'
# Makes one
# Try 'Makes two'
# Makes two
# Try 'Go! go! go!'
# Try 'Makes four'
# Makes four
```

--

# Exceptions hierarchy

```sh
Exception
  - fatal # impossible to rescue
  - NoMemoryError
  - ScriptError
    - LoadError
    - NotImplementedError
    - SyntaxError
  - SignalException
    - Interrupt
  - StandardError # default for `rescue`
    - ArgumentError
    - IndexError
      - StopIteration
    - IOError
      - EOFError
    - LocalJumpError
    - NameError
      - NoMethodError
    - RangeError
      - FloatDomainError
    - RegexpError
    - RuntimeError # default for `raise`
    - SecurityError
    - SystemCallError
      - Errno::\*
    - SystemStackError
    - ThreadError
    - TypeError
    - ZeroDivisionError
  - SystemExit
```

---

# Tasks

## Library

- Book: title, author
- Order: book, reader, date
- Reader: name, email, city, street, house
- Author: name, biography
- Library: books, orders, readers, authors

---

# Tasks

## Write program that determines:

- Who often takes the book
- What is the most popular book
- How many people ordered one of
  the three most popular books
- Save all Library data to file(s)
- Get all Library data from file(s)


---

# Ruby Koans

The [Ruby Koans](http://rubykoans.com/) are a great way to learn about the Ruby language.

```sh
$ git clone git://github.com/edgecase/ruby_koans.git ruby_koans
$ cd ruby_koans
```

```sh
$ rake gen
$ mkdir -p koans
$ cp src/edgecase.rb koans/edgecase.rb
$ cp README.rdoc koans/README.rdoc
```

```sh
$ rake

The Master says:
You have not yet reached enlightenment.
The answers you seek...
Failed assertion, no message given.
Please meditate on the following code:
/Users/sparrow/Www/ruby_koans/koans/about_asserts.rb:10:in 'test_assert_truth'
mountains are merely mountains
your path thus far [X_________________________________________________] 0/280
```

---

# The End

<br>

[Go to Table of Contents](/)
