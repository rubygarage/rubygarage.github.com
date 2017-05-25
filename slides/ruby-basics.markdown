---
layout: slide
title:  Ruby basics
---

![](/assets/images/ruby.png)

# Ruby is...

> A dynamic, open source programming language with a focus on simplicity and productivity.
> It has an elegant syntax that is natural to read and easy to write.

---

# RVM

--

## RVM first

![](/assets/images/rvm.png)

Visit https://rvm.io for more details.

```sh
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ \curl -sSL https://get.rvm.io | bash -s stable
$ rvm install 2.3.0
$ rvm use 2.3.0
$ rvm gemset create project_name
$ rvm gemset use project_name
```

--

## Supported files

- `.rvmrc` - shell script allowing full customization of the environment
- `.versions.conf` - key=value configuration file
- `.ruby-version` - single line ruby-version only
- `.ruby-gemset` - single line ruby-gemset only
- `Gemfile` - comment: #ruby=2.3.0 and directive: ruby '2.3.0'

--

.rvmrc <!-- .element: class="filename" -->
```sh
rvm use 2.0.0@project_name --create
```

.ruby-version <!-- .element: class="filename" -->
```sh
2.0.0-p247
```

.ruby-gemset <!-- .element: class="filename" -->
```sh
project_name
```

--

## RVM Best Practices
- Use `.ruby-version` and `.ruby-gemset` files for each of your individual projects
- Check your `.ruby-version` file into source control
- Use per-project gemsets
- Deploy with rvm when possible

---

# Run Ruby

--

## Run Ruby files

hello_world.rb <!-- .element: class="filename" -->

```ruby
puts 'Hello Ruby world!'
```

```sh
$ ruby hello_world.rb
Hello Ruby world!
```

hello_world.rb <!-- .element: class="filename" -->

```ruby
#!/usr/bin/ruby
puts 'Hello Ruby world!'
```

```sh
$ ./hello_world.rb
Hello Ruby world!
```

--

## Interactive Ruby

```ruby
$ irb
puts 'Hello Ruby world!'
# Hello Ruby world!
# => nil
```

---

# Everything is an object

--

## In Ruby, everything is an object.

```ruby
'alice'.capitalize
# => "Alice"

5.next
# => 6

false.class
# => FalseClass

[5, 12, 4].sort
# => [4, 5, 12]

Object.methods
# => [:new, :allocate, :superclass, :<=>, :module_exec, :class_exec, :<=, :>=, :==, :===, :include?, ... ]
```

---

# Numbers

--

## Numbers

```ruby
100.class
# => Fixnum

10000000000000000000.class
# => Bignum

100.0.class
# => Float
```

--

## Numbers conversion

```ruby
1 + 2
# => 3

1 + 2.0
# => 3.0

1.0 + 2
# => 3.0

1 / 2
# => 0

1.0 / 2
# => 0.5

1 / 2.0
# => 0.5
```

--

## Arithmetic operators

Assume variable `a` holds `10` and variable `b` holds `20` then:

| Operator | Description                                                                     | Example                             |
|----------|---------------------------------------------------------------------------------|-------------------------------------|
| +        | Addition - Adds values on either side of the operator                           | a + b will give 30                  |
| -        | Subtraction - Subtracts right hand operand from left hand operand               | a - b will give -10                 |
| \*       | Multiplication - Multiplies values on either side of the operator               | a \* b will give 200                |
| /        | Division - Divides left hand operand by right hand operand                      | b / a will give 2                   |
| %        | Modulus - Divides left hand operand by right hand operand and returns remainder | b % a will give 0                   |
| \*\*     | Exponent - Performs exponential (power) calculation on operators                | a\*\*b will give 10 to the power 20 |

--

## Assignment Operators

Assume variable `a` holds `10` and variable `b` holds `20` then:

| Operator | Description                                                                                                                  | Example                                      |
|----------|------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| =        | Simple assignment operator, Assigns values from right side operands to left side operand                                     | c = a + b will assigne value of a + b into c |
| +=       | Add AND assignment operator, It adds right operand to the left operand and assign the result to left operand                 | c += a is equivalent to c = c + a            |
| -=       | Subtract AND assignment operator, It subtracts right operand from the left operand and assign the result to left operand     | c -= a is equivalent to c = c - a            |
| \*=      | Multiply AND assignment operator, It multiplies right operand with the left operand and assign the result to left operand    | c \*= a is equivalent to c = c \* a          |
| /=       | Divide AND assignment operator, It divides left operand with the right operand and assign the result to left operand         | c /= a is equivalent to c = c / a            |
| %=       | Modulus AND assignment operator, It takes modulus using two operands and assign the result to left operand                   | c %= a is equivalent to c = c % a            |
| \*\*=    | Exponent AND assignment operator, Performs exponential (power) calculation on operators and assign value to the left operand | c \*\*= a is equivalent to c = c \*\* a      |

### Safe navigation Operator (only 2.3.0)

| Operator | Description                                                                                                | Example |
|----------|------------------------------------------------------------------------------------------------------------|---------|
| &.       | Makes it safer to chain multiple methods together. Execution stopes if method doesn’t exist or returns nil | a&.b&.c |

---

# Strings

--

## Create string

```ruby
'New string'
# => New string

"New string"
# => New string

String.new
# => ""
```

--

## Interpolation

```ruby
"Seconds/day: #{24 * 60 * 60}"
# => Seconds/day: 86400

'Seconds/day: #{24 * 60 * 60}'
# => Seconds/day: #{24 * 60 * 60}

"Tro #{'Lo ' * 3}!!!1"
# => Tro Lo Lo Lo !!!1

"Now is #{
          def the(a)
            'the ' + a
          end
          the('time')
        } for all good coders ..."
# => Now is the time for all good coders ...
```

--

## Concatenation

```ruby
'Con' "cat" 'ena' "te"
# => "Concatenate"

'Con' + "cat" + 'ena' + "te"
# => "Concatenate"

str = 'Programming!'
# => "Programming!"

str << ', I love it!'
# => "Programming! I love it!"

str.concat(' What about you?')
# => "Programming! I love it! What about you?"
```

--

## Accessing

```ruby
str = 'Programming! I love it! What about you?'
# => "Programming! I love it! What about you?"

str[13]
# => "I"

str.slice(13)
# => "I"

str[13, 10]
# => "I love it!"

str.slice(13, 12)
# => "I love it!"

str[13..-17]
# => "I love it!"

str['I love it!']
# => "I love it!"

str[/[abc](.)\1/]
# => "amm"
```

--

## Useful methods

Follow by http://ruby-doc.org/core-2.3.0/String.html for more information

```ruby
'pROgraMMing'.capitalize
# => "Programming"

'Programming'.downcase
# => "programming"

'Programming'.chars
# => #<Enumerator: "Programming":chars>

'Programming'.index('gra')
# => 3

'Programming'.insert(0, 'Extreme ')
# => "Extreme Programming"
```

--

## Useful methods

Follow by http://ruby-doc.org/core-2.3.0/String.html for more information

```ruby
'Programming'.match(/(.)\1/)
# => #<MatchData "mm" 1:"m">

'Programming'.partition('gra')
# => ["Pro", "gra", "mming"]

'Programming'.reverse
# => "gnimmargorP"

'Programming! I love it! What about you?'.split
# => ["Programming!", "I", "love", "it!", "What", "about", "you?"]

'Programming!_I love it!_What about you?'.split('_')
# => ["Programming!", "I love it!", "What about you?"]
```

---

# Arrays

--

## Array

> Arrays are ordered, integer-indexed collections of any object.

> Array indexing starts at 0, as in C or Java.
> A negative index is assumed to be relative to the end of the array — that is, an index of -1 indicates the last element of the array

Follow by http://ruby-doc.org/core-2.3.0/Array.html for more information

--

## Creating

```ruby
[[1, 2, 3], 10, 3.14, 'This is a string', barnet('pebbles')]
# => [[1, 2, 3], 10, 3.14, "This is a string", "pebbles results"]

Array.new
# => []

Array.new(3)
# => [nil, nil, nil]

Array.new(3, true)
# => [true, true, true]

Array.new(4) { Hash.new }
# => [{}, {}, {}, {}]

Array({ a: 'a', b: 'b' })
# => [[:a, "a"], [:b, "b"]]

%w(monkey fish lion dog cat #{Time.now})
# => ["monkey", "fish", "lion", "dog", "cat", "\#{Time.now}"]

%W(monkey fish lion dog cat #{Time.now})
# => ["monkey", "fish", "lion", "dog", "cat", "2013-05-03 12:24:42 +0300"]
```

--

## Accessing elements

```ruby
languages = 'Ruby', 'JavaScript', 'Python', 'PHP'
# => ["Ruby", "JavaScript", "Python", "PHP"]

languages.at(0)
# => "Ruby"

languages[0]
# => "Ruby"

languages[4]
# => nil

languages[2..3]
# => ["Python", "PHP"]

languages.take(3)
# => ["Ruby", "JavaScript", "Python"]

languages[1] = 'CoffeeScript'
# => "CoffeeScript"

languages
# => ["Ruby", "CoffeeScript", "Python", "PHP"]
```

--

## Extracts the nested value (only from 2.3.0)

```ruby
a = [[1, [2, 3]]]

a.dig(0, 1, 1)
# => 3

a.dig(1, 2, 3)
# => nil

a.dig(0, 0, 0)
# => NoMethodError, undefined method 'dig' for 1:Fixnum

[42, {foo: :bar}].dig(1, :foo)
# => :bar
```

--

## Adding items

```ruby
languages = ['Ruby', 'JavaScript', 'Python', 'PHP']
# => ["Ruby", "JavaScript", "Python", "PHP"]

languages.push('Closure')
# => ["Ruby", "JavaScript", "Python", "PHP", "Closure"]

languages << 'Haskell'
# => ["Ruby", "JavaScript", "Python", "PHP", "Closure", "Haskell"]

languages.unshift('C++')
# => ["C++", "Ruby", "JavaScript", "Python", "PHP", "Closure", "Haskell"]

languages.insert(3, 'CoffeeScript')
# => ["C++", "Ruby", "JavaScript", "CoffeeScript", "Python", "PHP", "Closure", "Haskell"]

languages.insert(4, 'Haml', 'Sass')
# => ["C++", "Ruby", "JavaScript", "CoffeeScript", "Haml", "Sass", "Python", "PHP", "Closure", "Haskell"]
```

--

## Removing items

```ruby
languages = ['C++', 'Ruby', 'JavaScript', 'CoffeeScript', 'Haml', 'Sass', 'Python', 'PHP', 'Closure', 'Haskell']
# => ["C++", "Ruby", "JavaScript", "CoffeeScript", "Haml", "Sass", "Python", "PHP", "Closure", "Haskell"]

languages.pop
# => "Haskell"

languages
# => ["C++", "Ruby", "JavaScript", "CoffeeScript", "Haml", "Sass", "Python", "PHP", "Closure"]

languages.shift
# => "C++"

languages
# => ["Ruby", "JavaScript", "CoffeeScript", "Haml", "Sass", "Python", "PHP", "Closure"]

languages.delete_at(2)
# => "CoffeeScript"

languages
# => ["Ruby", "JavaScript", "Haml", "Sass", "Python", "PHP", "Closure"]

languages.delete('PHP')
# => "PHP"
```

--

## Removing items

```ruby
languages
# => ["Ruby", "JavaScript", "Haml", "Sass", "Python", "Closure"]

languages = ['Ruby', 'JavaScript', nil, 0, 'Python', nil]
# => ["Ruby", "JavaScript", nil, 0, "Python", nil]

languages.compact
# => ["Ruby", "JavaScript", 0, "Python"]

languages = ['Ruby', 'JavaScript', 'PHP', 'Python', 'PHP']
languages.uniq
# => ["Ruby", "JavaScript", "PHP", "Python"]
```

--

## Obtaining information

```ruby
languages = ['Ruby', 'JavaScript', 'PHP', 'Python', 'PHP']
# => ["Ruby", "JavaScript", "PHP", "Python", "PHP"]

languages.length
languages.count
languages.size
# => 5

languages.empty?
# => false

languages.any?
# => true

languages.include?('Ruby')
# => true

languages.include?('Closure')
# => false
```

--

## Concatenation

```ruby
days1 = ['Mon', 'Tue', 'Wed']
days2 = ['Thu', 'Fri', 'Sat', 'Sun']

days1 + days2
# => ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

days1.concat(days2)
# => ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

days1 = ['Mon', 'Tue', 'Wed']

days1 << 'Thu' << 'Fri' << 'Sat' << 'Sun'
# => ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
```

--

## Operations

```ruby
os = ['Fedora', 'SUSE', 'Red Hat', 'MacOS', 'Windows']
linux_os = ['SUSE', 'Red Hat', 'Ubuntu', 'Fedora']
```

Union

```ruby
os | linux_os
# => ["Fedora", "SUSE", "Red Hat", "MacOS", "Windows", "Ubuntu"]
```

Intersection

```ruby
os & linux_os
# => ["Fedora", "SUSE", "Red Hat"]
```

Difference

```ruby
os - linux_os
# => ["MacOS", "Windows"]

linux_os - os
# => ["Ubuntu"]
```

--

## Operations

```ruby
os = ['Fedora', 'SUSE', 'Red Hat', 'MacOS', 'Windows']
linux_os = ['SUSE', 'Red Hat', 'Ubuntu', 'Fedora']
```

Addition

```ruby
linux_os + ['Debian', 'Gentoo']
# => ["SUSE", "Red Hat", "Ubuntu", "Fedora", "Debian", "Gentoo"]
```

Multiplication

```ruby
linux_os * 2
# => ["SUSE", "Red Hat", "Ubuntu", "Fedora", "SUSE", "Red Hat", "Ubuntu", "Fedora"]

linux_os * ', '
# => "SUSE, Red Hat, Ubuntu, Fedora"
```

--

## Iterators

each

```ruby
a = ['a', 'b', 'c']
a.each { |x| print x, ' -- ' }
# a -- b -- c --
```

each_index

```ruby
a = ['a', 'b', 'c']
a.each_index { |x| print x, ' -- ' }
# 0 -- 1 -- 2 --
```

each_with_index

```ruby
a = ['a', 'b', 'c']
a.each_with_index { |item, index| puts "[#{index}] => #{item}" }
# [0] => a
# [1] => b
# [2] => c
```

---

# Symbols

> Ruby uses symbols, and maintains a Symbol Table to hold them. Symbols are names — names of instance variables, names of
methods, names of classes. A Symbol object is created by prefixing an operator, string, variable, constant, method,
class, module name with a colon. Symbols are immutable. The symbol object will be unique for each different name but
does not refer to a particular instance of the name, for the duration of a program's execution.

Follow by http://www.ruby-doc.org/core-2.3.0/Symbol.html for more information.

--

## Symbol

```ruby
:ruby_rules
# => :ruby_rules

:"Ruby rules"
# => :"Ruby rules"

language = 'Ruby'
:"#{language} rules"
# => :"Ruby rules"

:ruby.object_id
# => 319048

:ruby.object_id
# => 319048

'ruby'.object_id
# => 70200985531220

'ruby'.object_id
# => 70200985514360
```

---

# Hashes

> A Hash is a collection of key-value pairs. It is similar to an Array (sometimes it is called an associative array),
except that indexing is done via arbitrary keys of any object type, not an integer index.

Follow by http://www.ruby-doc.org/core-2.3.0/Hash.html for more information.

--

## Creating

```ruby
{ 'font_size' => 10, 'font_family' => 'Arial' }
# => {"font_size"=>10, "font_family"=>"Arial"}

{ :font_size => 10, :font_family => 'Arial' } # Old hash-rocket style
# => {:font_size=>10, :font_family=>'Arial'}

{ font_size: 10, font_family: 'Arial' } # New hash-colon style
# => {:font_size=>10, :font_family=>"Arial"}

Hash.new
# => {}

Hash['a' => 100, 'b' => 200]
# => {"a"=>100, "b"=>200}
```

--

## Default value

```ruby
h = Hash.new('Default value')
# => {}

h['key']
# => "Default value"

h = Hash.new { |hash, key| hash[key] = "Default value: #{key}" }
# => {}

h['key']
# => "Default value: key"

h = Hash.new
h.default = 'Default value'

h['key']
# => "Default value"
```

--

## Removing items

delete

```ruby
h = { a: 100, b: 200 }
h.delete(:a)
# => 100

h.delete(:z)
# => nil
```

delete_if

```ruby
h = { a: 100, b: 200, c: 300 }
h.delete_if { |key, value| value > 100 }
# => {"a"=>100}
```

--

## Removing items

keep_if

```ruby
h = { a: 100, b: 200, c: 300 }
h.keep_if { |key, value| value > 100 }
# => {"b"=>200, "c"=>300}
```

shift

```ruby
h = { 1 => 'a', 2 => 'b', 3 => 'c' }
h.shift
# => [1, "a"]

h
# => {2=>"b", 3=>"c"}
```

--

## Useful methods

each

```ruby
h = { a: 100, b: 200 }
h.each { |key, value| puts "#{key} is #{value}" }
# a is 100
# b is 200
# => {"a"=>100, "b"=>200}
```

each_key

```ruby
h = { a: 100, b: 200 }
h.each_key { |key| puts key }
# a
# b
# => {"a"=>100, "b"=>200}
```

each_value

```ruby
h = { a: 100, b: 200 }
h.each_value { |value| puts value }
# 100
# 200
# => {"a"=>100, "b"=>200}
```

--

## Useful methods

key?

```ruby
h = { a: 100, b: 200 }

h.key?(:a)
# => true

h.key?(:z)
# => false
```

value?

```ruby
h = { a: 100, b: 200 }

h.value?(100)
# => true

h.value?(999)
# => false
```

--

## Useful methods

keys

```ruby
h = { a: 100, b: 200 }

h.keys
# => ["a", "b"]
```

values

```ruby
h = { a: 100, b: 200, c: 300 }

h.values
# => [100, 200, 300
```

values_at

```ruby
h = { a: 100, b: 200, c: 300 }

h.values_at('a', 'c')
# => [100, 300]
```

--

## Useful methods

length

```ruby
h = { d: 100, a: 200, v: 300, e: 400 }

h.length
# => 4

h.delete('a')
# => 200

h.length
# => 3
```

merge

```ruby
h1 = { a: 100, b: 200 }
h2 = { b: 254, c: 300 }

h1.merge(h2)
# => {"a"=>100, "b"=>254, "c"=>300}
```

--

## Useful methods

select

```ruby
h = { a: 100, b: 200, c: 300 }

h.select { |key, value| value > 100}
# => {"b"=>200, "c" =>300}
```

dig (2.3.0 only)

```ruby
h = { a: { b: { c: 1 } } }

h.dig(:a, :b, :c)
# => 1

h.dig(:a, :some, :c)
# => nil

h[:a][:some][:c]
# => NoMethodError: undefined method '[]' for nil:NilClass

h = { a: [10, 11, 12] }

h.dig(:a, 1)
# => 11
```

---

# Ranges

> A Range represents an interval — a set of values with a beginning and an end.

Follow by http://www.ruby-doc.org/core-2.3.0/Range.html for more information.

--

Creates a range from `1` to `10` inclusive

```ruby
1..10
(1..10).to_a
# => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

Creates a range from `1` to `10`

```ruby
1...10
(1...10).to_a
# => [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

Creates a range from `a` to `e`

```ruby
('a'..'e').to_a
# => ["a", "b", "c", "d", "e"]
```

---

# Time

> Time is an abstraction of dates and times.

Follow by http://www.ruby-doc.org/core-2.3.0/Time.html for more information.

--

## Time

```ruby
Time.new(2016)
# => 2016-01-01 00:00:00 +0200

Time.new(2016, 10)
# => 2016-10-01 00:00:00 +0300

Time.new(2016, 10, 30, 2, 2, 2, '+03:00')
# => 2016-10-30 02:02:02 +0300

Time.at(628232400)
# => 1989-11-28 08:00:00 +0300
```

--

## Time

```ruby
t = Time.new
# => 2013-05-09 18:50:25 +0300

t.year
# => 2013

t.month
# => 5

t.day
# => 9

t.wday
# => 4

t.yday
# => 129
```

--

## Time

```ruby
t = Time.new
# => 2013-05-09 18:50:25 +0300

t.hour
# => 18

t.min
# => 50

t.sec
# => 25

t.zone
# => "EEST"

t.strftime('%Y-%m-%d %H:%M:%S')
# => "2013-05-09 18:50:25"
```

---

# File

> A `File` is an abstraction of any file object accessible by the program and is closely associated with class `IO`.

Follow by http://www.ruby-doc.org/core-2.3.0/File.html for more information.

--

## Open and close

new

```ruby
File.new('tmp.txt', 'w')
# => #<File:tmp.txt>
```

open, close

```ruby
f = File.open('tmp.txt', 'r')
# => #<File:tmp.txt>

f.closed?
# => false

f.close

f.closed?
# => true
```

--

## Read

read

```ruby
File.read('tmp.txt')
# => "This is line one\nThis is line two\nThis is line three\nAnd so on...\n"

File.read('tmp.txt', 20)
# => "This is line one\nThi"

File.read('tmp.txt', 20, 10)
# => "ne one\nThis is line "
```

gets

```ruby
f = File.open('tmp.txt', 'r')

while line = f.gets
  print line
end
```

--

## Read

readlines

```ruby
a = File.readlines('tmp.txt')

a[0]
# => "This is line one\n"

a[1]
# => "This is line two\n"
```

each

```ruby
f = File.open('tmp.txt', 'r')

f.each do |line|
  print line
end
```

--

## Write, rename, delete

write, puts

```ruby
f = File.open('tmp.txt', 'w')
f.write('new text')
```

rename

```ruby
File.rename('old_name.txt', 'new_name.txt')
```

delete

```ruby
File.delete('file.txt')
```

--

## Useful methods

ftype

```ruby
File.ftype('file.txt')
# => "file"

File.ftype('.')
# => "directory"
```

join

```ruby
File.join('usr', 'mail', 'gumby')
# => "usr/mail/gumby"
```

expand_path

```ruby
File.expand_path(__FILE__)
# => "/home/oracle/bin"
```

---

# Dir

> Objects of class Dir are directory streams representing directories in the underlying file system.
They provide a variety of ways to list directories and their contents.

Follow by http://ruby-doc.org/core-2.3.0/Dir.html for more information.

--

entries

```ruby
Dir.entries('testdir')
# => [".", "..", "config.h", "main.rb"]
```

glob

```ruby
Dir.glob('*.[a-z][a-z]')
# => ["main.rb"]
```

foreach

```ruby
Dir.foreach('testdir') { |x| puts "Got #{x}" }
# Got .
# Got ..
# Got config.h
# Got main.rb
```

mkdir

```ruby
Dir.mkdir(File.join(Dir.home, '.foo'), 0700)
```

---

# Variables

--

## Local

```ruby
v = 'Ruby'
# => "Ruby"

v.class
# => String

v.kind_of? String
# => true

v.is_a? String
# => true

v.instance_of? String
# => true

defined? v
# => "local-variable"
```

--

## Instance

```ruby
@i = 'Ruby'
# => "Ruby"

defined? @i
# => "instance-variable"
```

--

## Global

```ruby
$g = 'Ruby'
# => "Ruby"

defined? $g
# => "global-variable"
```

--

## Constant

```ruby
C = 'Ruby'
# => "Ruby"

defined? C
# => "constant"
```

---

# Conditional statements

--

## If, unless

```ruby
if a == 4
  a = 7
end
```

```ruby
if a == 4 then a = 7 end
```

```ruby
a = 7 if a == 4
```

```ruby
if a != 4
  a = 7
end
```

```ruby
unless a == 4
  a = 7
end
```

```ruby
a = 7 unless a == 4
```

--

## Using

Bad

```ruby
unless some_condition?
  # do something
else
  # do something else
end
```

Good

```ruby
if some_condition?
  # do something else
else
  # do something
end
```

--

## Using

Bad

```ruby
unless some.nil?
  # do something
end
```

Good

```ruby
if some
  # do something
end
```

--

## Using

Bad

```ruby
unless first_condition? && second_condition?
  # do something
end
```

Good

```ruby
if !first_condition? || !second_condition?
  # do something
end
```

--

## If, elsif, else

```ruby
a = 1
res = if a < 5
        "#{a} less than 5"
      elsif a > 5
        "#{a} greater than 5"
      else
        "#{a} equals 5"
      end
res
# => "1 less than 5"
```

--

## Short-if expression

```ruby
true ? 't' : 'f'
# => "t"

false ? 't' : 'f'
# => "f"
```

--

## and

```ruby
nil && 99
# => nil

false && 99
# => false

'cat' && 99
# => 99
```

--

## or

```ruby
nil || 99
# => 99

false || 99
# => 99

'cat' || 99
# => "cat"
```

--

At first glance it appears to be synonyms for `&&` and `||` and and or.
You will then be tempted to use these them in place of `&&` and `||` to improve readability.
But `and` and `or` don’t behave like their symbolic kin.

```ruby
one = :one
two = nil

t = one and two
# => nil

t
# => :one

t = one && two
# => nil

t
# => nil

t = (one and two)
# => nil

t
# => nil

(t = one) && two
# => nil

t
# => :one
```

--

## Case, when

```ruby
a = 1
r = case
    when a < 5
      "#{a} less than 5"
    when a > 5
      "#{a} greater than 5"
    else
      "#{a} equals 5"
    end
r
# => "1 less than 5"
```

```ruby
a = 1
case a
when 0...5
  "#{a} greater than 0 less than 5"
when 5
  "#{a} equals 5"
when 5..Float::INFINITY
  "#{a} greater than 5"
else
  "#{a} less than 0"
end
# => "1 greater than 0 less than 5"
```

--

## Loop

```ruby
i = 0

loop do
  i += 1

  next if i == 5

  print "#{i} "

  break if i == 10
end
# => 1 2 3 4 6 7 8 9 10
```

--

## While

```ruby
i = 1

while i < 11
  print "#{i} "

  i += 1
end
# => 1 2 3 4 6 7 8 9 10
```

--

## Like do...while

```ruby
i = 11

begin
  print "#{i} "

  i += 1
end while i < 10
# => 11
```

--

## Until

```ruby
i = 1

until i > 10
  print "#{i} "

  i += 1
end
# => 1 2 3 4 6 7 8 9 10
```

--

## For

```ruby
for i in 1..10
  print "#{i} "
end
# => 1 2 3 4 6 7 8 9 10
```

--

## Each

```ruby
[1,2,3,4,5,6,7,8,9,10].each { |value| print "#{value} " }
# => 1 2 3 4 6 7 8 9 10
```

--

## Times

```ruby
10.times { |i| print "#{i} " }
# => 0 1 2 3 4 6 7 8 9
```

--

## Upto

```ruby
1.upto(10) { |i| print "#{i} " }
# => 1 2 3 4 6 7 8 9 10
```

---

# Methods

--

## Methods

```ruby
'Goonies has a rank of 10'
'Ghostbusters has a rank of 9'
'Goldfinger has a rank of 8'
```

```ruby
def movie_listing(title, rank = 5)
  "#{title.capitalize} has a rank of #{rank}"
end

movie_listing('goonies', 10)
# => "Goonies has a rank of 10"

movie_listing('ghostbusters', 9)
# => "Ghostbusters has a rank of 9"

movie_listing('goldfinger')
# => "Goldfinger has a rank of 5"
```

--

## Definition

```ruby
def my_method
  # Code for the method would be here
end

def my_method_with_arguments(arg1, arg2, arg3)
  # Code for the method would be here
end
```

```ruby
def cool_dude(arg1 = 'Miles', arg2 = 'Coltrane', arg3 = 'Roach')
  "#{arg1}, #{arg2}, #{arg3}"
end

cool_dude
# => "Miles, Coltrane, Roach"

cool_dude('Bart')
# => "Bart, Coltrane, Roach"

cool_dude('Bart', 'Elwood')
# => "Bart, Elwood, Roach"

cool_dude('Bart', 'Elwood', 'Linus')
# => "Bart, Elwood, Linus"
```

--

## Arguments

```ruby
def var_args(a, b, c=1, *d, e, f)
  puts "required a #{a}"
  puts "required b #{b}"
  puts "optional c #{c}"
  puts "argument array d #{d.inspect}"
end

var_args(1,2,3,4,5,6,7,8,9)
# required a 1
# required b 2
# optional c 3
# argument array d [4, 5, 6, 7]
# => nil
```

--

## Invalid order

sponge arguments `*` should be always after optional

```ruby
def invalid_args(x, *y ,z = 1) end
```

## More examples

```ruby
def split_apart(first, *split, last)
  "first: #{first.inspect}, split: #{split.inspect}, last: #{last.inspect}"
end

split_apart(1, 2)
# => "first: 1, split: [], last: 2"

split_apart(1, 2, 3)
# => "first: 1, split: [2], last: 3"

split_apart(1, 2, 3, 4)
# => "first: 1, split: [2, 3], last: 4"
```

```ruby
def split_apart(first, *, last)
  # ...
end
```

--

## Return values

```ruby
def meth_one
  'one'
end

meth_one
# => "one"
```

```ruby
def meth_two(arg)
  if arg > 0
    'positive'
  elsif arg < 0
    'negative'
  else
    'zero'
  end
end

meth_two(23)
# => "positive"

meth_two(0)
# => "zero"
```

--

## Return values

```ruby
def meth_three
  100.times do |num|
    square = num * num

    return num if square > 1000
  end
end

meth_three
# => 32
```

--

## Blocks

> A block is code that is passed to a method by using of either curly braces, `{...}`, or do...end syntax.
It's common convention to use `{...}` for single line blocks, and `do...end` for multi-line blocks,
but curly braces have higher precedence.

--

## Using blocks

1. Passed as a method argument, using the special `&` last-argument syntax sugar operator or a `block_given?`/`yield`
pair.

2. As a `Proc` object (or the `lambda`).

  **Important:**
  1. You can pass only one block to method.
  2. Block should follow method arguments braces.

3. Block hasn't access to method local variables but we can pass them to block. And They can be changed inside block.

4. If method local variable has te same name as block local variable then method local variable is not availaba inside
block.

5. Arguments number is important for method and not important for block.

6. if you want to pass as method argument you must use braces otherwise it is treated as block and rises an error.

--

## Using blocks

```ruby
def double(p1)
  yield(p1*2)
end

double(3) { |val| "I got #{val}" }
# => "I got 6"

double('tom') do |val|
  "Then I got #{val}"
end
# => "Then I got tomtom"
```

--

## Using blocks

```ruby
def try
  if block_given?
    yield
  else
    'no block'
  end
end

try
# => "no block"

try { 'hello' }
# => "hello"

try do 'hello' end
# => "hello"
```

--

## Closures

```ruby
def thrice
  yield
  yield
  yield
end

x = 5

puts "value of x before: #{x}"
# => "value of x before: 5"

thrice { x += 1 }

puts "value of x after: #{x}"
# => "value of x after: 8"
```

--

## Convert the block to a Proc

```ruby
def thrice
  yield
  yield
  yield
end

def seven_times(&block)
  block.call
  thrice(&block)
  thrice(&block)
end

x = 4

seven_times { x += 10 }
# => 74
```

```ruby
def what_am_i(&block)
  block.class
end

what_am_i {}
# => Proc
```

--

## Proc aka procedure

```ruby
square = Proc.new do |n|
  n ** 2
end

square.call(2)
# => 4

square.call(4)
# => 16
```
<!-- .element: class="left width-50" -->

```ruby
square = proc do |n|
  n ** 2
end

square.call(2)
# => 4

square.call(4)
# => 16
```
<!-- .element: class="right width-50" -->

--

## Anonymous

```ruby
bo = lambda do |param|
  "You called me with #{param}"
end

bo.call(99)
# => "You called me with 99"
```
<!-- .element: class="left width-50" -->

```ruby
bo = ->(param) { "You called me with #{param}" }

bo.call(99)
# => "You called me with 99"
```
<!-- .element: class="right width-50" -->

--

## Proc vs lambda

> Lambdas check the number of arguments

```ruby
def args(code)
  one, two = 1, 2
  code.call(one, two)
end

args(Proc.new{ |a, b, c| puts "Give me a #{a} and b #{b} and c #{c}"})
# Give me a 1 and b 2 and c

args(lambda{ |a, b, c| puts "Give me a #{a} and b #{b} and c #{c}"})
# => ArgumentError: wrong number of arguments (2 for 3)
```

--

## Proc vs lambda

> Lambdas have lesser returns

```ruby
def proc_return
  Proc.new { return 'Proc.new' }.call
  return 'proc_return return'
end

def lambda_return
  lambda { return 'lambda' }.call
  return 'lambda_return return'
end

proc_return
# => "Proc.new"

lambda_return
# => "lambda_return return"
```

--

## Proc vs lambda

### Conclusion

- `blocks` and `Procs` act like code snippets
- `lambdas` and `Methods` act like methods

--

## Method to object

```ruby
def square(n)
  n ** 2
end

square_obj = method(:square)

square_obj.class
# => Method

square_obj.call(4)
# => 16
```

--

## Naming

### `?` - return true or false

```ruby
movie = ''
movie.empty?
# => true

movie = 'Goonies'
movie.empty?
# => false

movie.include?('G')
# => true

movie.include?('x')
# => false
```

--

### `!` - change the current object

```ruby
movie = 'Ghostbusters'
# => "Ghostbusters"

movie.reverse
# => "sretsubtsohG"

movie
# => "Ghostbusters"

movie.reverse!
# => "sretsubtsohG"

movie
# => "sretsubtsohG"
```

--

## Operators

```ruby
num = 12
# => 12

num * 2
# => 24

num.*(2)
# => 24
```

---

# Ruby Koans

--

## Ruby Koans Online

The [Ruby Koans](http://rubykoans.com/) are a great way to learn about the Ruby language.

```bash
$ git clone git://github.com/edgecase/ruby_koans.git ruby_koans
$ cd ruby_koans
```

```bash
$ rake gen
$ mkdir -p koans
$ cp src/edgecase.rb koans/edgecase.rb
$ cp README.rdoc koans/README.rdoc
```

```bash
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
