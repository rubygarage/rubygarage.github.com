---
layout: slide
title:  Refactoring
---

# Refactoring

---

# Refactoring

Refactoring is the process of changing a software system in such a way that it does not alter the external behavior of the code yet improves its internal structure.

---

# Code smell

> Code smell is any symptom in the source code of a program that possibly indicates a deeper problem. Code smells are usually not bugs they are not technically incorrect and don't currently prevent the program from functioning. Instead, they indicate weaknesses in design that may be slowing down development or increasing the risk of bugs or failures in the future.

---

# The Refactoring Cycle

* Start with working, tested code while the design can be simplified
* Choose the worst smell
* Apply the refactoring
* Check that the tests still pass

---

# Duplicated Code

* The easy form: Two fragments of code look nearly identical.
* The hard form: Two fragments of code have nearly identical effects (at any conceptual level).

--

## Problems

* Size: The code is bigger than it has to be, with more to understand.
* Flexibility: The change may have to be done in multiple places.
* Communication: The reader must decide whether two things are really expressing one concept, and whether any differences are significant.

--

## What to Do

* If in same class [Extract Method](refactoring-ruby#/21)
* If in two subclasses [Extract Method](refactoring-ruby#/21) or [Pull Up Method](refactoring-ruby#/26)
* If not identical [Form Template Method](refactoring-ruby#/29) or [Subtitute Algorithm](refactoring-ruby#/44)
* If in unrelated locns [Extract Class](refactoring-ruby#/23) or [Extract Module](refactoring-ruby#/25)

---

# Long Method

* A method has a large number of lines. (We’re immediately suspicious of any method with more than five lines.)

--

## Problems

* Flexibility: A Long Method is guaranteed to be a Greedy Method at least two responsibilities are coupled together in
one place, which in turn leads to Divergent Change.
* Testability: It can be difficult to isolate individual behaviors of a Long Method for testing; and if a method does
too much it may also be difficult to create fixtures that contain enough context for the method to work properly.

--

## What to Do

* If no prob with params use [Extract Method](refactoring-ruby#/21) to break up the method into smaller pieces. Look
for comments or white space delineating interesting fragments. You want to extract methods that are semantically
meaningful, not just introduce a function call every seven lines.
* If the method doesn't separate easily into pieces, consider [Replace Method with Method Object](refactoring-ruby#/39) to turn the method into a separate object, or [Replace Temp with Query](refactoring-ruby#/40)
* If has loops and conditionals [Decompose Conditional](refactoring-ruby#/45) or Replace Loop with [Collection Closure Method](refactoring-ruby#/46)

---

# Long Parameter List

* A method has more than one or two parameters.
* A method yields more than one or two objects to an associated block.

--

## Problems

* Simplicity: A Long Parameter List often indicates that a method has more than one responsibility. Sometimes the
parameters have no meaningful grouping—they don’t go together. In such cases it may be that the method, or the
objects it uses, doesn’t represent a meaningful and cohesive abstraction in the problem domain.
* Flexibility: A Long Parameter List represents a large number of pieces of shared information between the caller and
called code. If either changes, the parameter list is likely to need changing too.
* Communication: A lot of parameters represent a lot to remember—the programmer has to remember not only what objects
to pass, but in which order. More succinct APIs are easier and quicker to use.

--

## What to Do

* If a parameter's value can be obtained from another object use [Replace Parameter with Method](refactoring-ruby#/35).
* If the parameters come from a single object, try [Preserve Whole Object](refactoring-ruby#/36).
* If the data is not from one logical object, you still might group them via [Introduce Parameter Object](refactoring-ruby#/37).
* Otherwise make clearer with [Introduce Named Parameter](refactoring-ruby#/47)

---

# Uncommunicative Name

> A name doesn't communicate its intent well enough. Examples of this can include:

* One or two character names (mn, ts, sc).
* Names with vowels omitted (lgn, psh).
* Numbered variables (pane1, pane2).
* Odd abbreviations (par, dis, mov).
* Variable names that reflect their type rather than their purpose or role (i_count, s_name).
* Misleading names.

--

## Problems

* Communication: Poor names deceive the reader; they make it harder to build a mental picture of what's going on, and
they can be misinterpreted. They also hurt the flow of reading as the reader must slow down to interpret the names.
* Flexibility: Very short names can be difficult to change, even with automated refactoring tools.

--

## What to Do

* Use [Rename Method](refactoring-ruby#/27) (or field, constant, etc.) to give it a better name

---

# Comments

The code contains a comment.

--

## Problems

* Flexibility: Any comment that explains the code must be kept in step if the code is changed.
* Duplication: Most comments can be reflected just as well in the code itself. For example, the goal of a method can
often be communicated as well through its name as it can through a comment.
* Communication: Comments that say something slightly different than the code create cognitive drag or even mistrust
and slow the reader down.

> Don’t delete comments that are pulling their own weight such as rdoc API documentation.

--

## What to Do

* When a comment explains a code fragment, you can often use [Extract Method](refactoring-ruby#/21) to pull the
fragment out into a separate method. The comment will often suggest a name for the new method.
* When a comment explains what a method does (better than the method's name!), use [Rename
Method](refactoring-ruby#/27) using the comment as the basis of the new name.
* When a comment explains preconditions, consider using [Introduce Assertion](refactoring-ruby#/33) to replace
the comment with code.

---

# Large Class or Module
A class or module has a large number of instance variables, methods, or just lines of code.

--

## Problems

* Testability: A Large Module is usually difficult to test, either because it depends on many other modules or because
it is difficult or time-consuming to create instances in isolation.
* Flexibility: The module represents too many responsibilities folded together that is, every Large Module is also a
Greedy Module.

--

## What to Do
* To break up the module further, use [Extract Class](refactoring-ruby#/23) or [Extract
Module](refactoring-ruby#/25) if you can identify a new piece that has part of this module's responsibilities
* Also will be useful [Replace Type Code with Polymorphism](refactoring-ruby#/41), [Replace Type Code with Module Extension](refactoring-ruby#/42), [Replace Type Code with State Strategy](refactoring-ruby#/43)
* Very often a review of the module reveals a composite of other smells, such as Long Methods, Data Clumps, and
Temporary Fields; fix these smells first.

---

# Shotgun Surgery

Making a simple change requires you to change several classes or modules.

--

## Problems

* Communication: You change a single decision and you have to change several classes, which probably means that the
decision doesn't have a name, and consequently the application's design isn't being clearly communicated. That
will cause current and future developers to need to search the code more, which may in turn lead to defects.
* Flexibility: It probably also means that the decision hasn't been isolated from other decisions. So some modules may
be harder to test than necessary, and some modules may churn for longer, perhaps never stabilizing.

--

## What to Do

* Identify the class or module that should own the group of changes. It may be an existing module, or you may need to
use [Extract Module](refactoring-ruby#/25) to create a new one.
* Use [Move Field](refactoring-ruby#/28) and Move Method to put the functionality onto the chosen module. After the
module not chosen is simple enough, you may be able to use Inline Module to eliminate it.

---

# Feature Envy

* A code fragment references another object more often than it references itself.
* Several clients do the same series of manipulations on a particular type of object.

--

## Problems

* Communication: Code that "belongs" on one class but is located in another can be hard to find and may upset the
System of Names in the host class.
* Flexibility: A code fragment that is in the wrong class creates couplings that may not be natural within the
application's domain and a loss of cohesion in the unwilling host class.
* Duplication: Existing functionality that is difficult to find is also easy to miss, which in turn may lead to it
being written more than once.

--

## What to Do

* If the envious code fragment is not isolated, use [Extract Method](refactoring-ruby#/21) to pull it into its own
method.
* Look for the class of the object that is referenced most and use [Move Field](refactoring-ruby#/28) and Move Method to
put the actions on the correct class.

---

# Data Clump

* The same two or three items frequently appear together in classes and parameter lists.
* A group of instance variable names start or end with similar substrings.

--

## Problems

* Duplication: The recurrence of the items often means there is duplicate code spread around to handle them.
* Abstraction: There may be a missing concept, making the system harder to understand.

--

## What to Do

* If the items are instance variables in a class, use [Extract Class](refactoring-ruby#/23) to pull them into a new
class.
* If the values are together in method signatures, use [Introduce Parameter Object](refactoring-ruby#/37), [Replace Array with Object](refactoring-ruby#/38) to extract the new object.

---

# Special Case

* Complex if statements
* Guard clauses checks for particular values before doing work (especially comparisons to constants)

--

## Problems

* Communication: A Special Case increases the amount the reader has to hold in his head while attempting to understand
a code fragment.

--

## What to Do

* If the conditionals are taking the place of polymorphism, [Replace Conditional with Polymorphism](refactoring-ruby#/41) or [Replace Type Code with Module Extension](refactoring-ruby#/42) or [Replace Type Code with State Strategy](refactoring-ruby#/43). You may find things become more clear if you first use Extract Method on the clauses.
* If used once [Replace Parameter with Method](refactoring-ruby#/35)
* If one branch is null [Introduce Null Object](refactoring-ruby#/34)
* If have dificult conditions use [Decompose conditional](refactoring-ruby#/45), [Substitute Algorithm](refactoring-ruby#/44), [Replace Method With Method Object](refactoring-ruby#/39)
* If the if and else clauses are similar enough, you may be able to rewrite them so that the same code fragment can
generate the proper results for each case; then the conditional can be eliminated.

---

# Control Coupling

* A method or block checks the value of a parameter in order to decide which execution path to take.
* A method's name includes a word such as "or."

--

## Problems

* Duplication: Control Coupling is a kind of duplication, because the caller already knows which path should be taken.
* Flexibility: The caller and callee are coupled together - any change to the possible values of the controlling
parameter must be reflected on both sides.
* Simplicity: The called method is probably also a Greedy Method, because it includes at least two different code
paths.

--

## What to Do

* Use [Extract Method](refactoring-ruby#/21) to strip the controlled method down to the bare skeleton.
* Then use [Inline Method](refactoring-ruby#/22) to push the responsibility back up to the caller(s).
* Repeat all the way up the call stack to the source of the control value.

---

# Greedy Method

* A method does more than one job.
* A method has “and” in its name.
* The body of a method includes code at several different levels of abstraction.

--

## Problems

* Communication: A code fragment that has two responsibilities intertwined is harder to read, and harder to name.
* Flexibility: If one of the method's responsibilities must change, or has a defect, you often have to work hard to
sidestep the method's other responsibilities - it can therefore be a challenge to avoid breaking other code.
* Testability: A method that does two things will be harder to test than if the responsibilities were separated.

--

## What to Do

* Consider the approaches to dealing with a [Long Method](#long-method) they will often work here just as well. Use
[Extract Method](refactoring-ruby#/21) to hide detail behind an intention revealing name.
* If the method makes extensive use of another object, treat and fix the [Feature Envy](#feature-envy).

---

# Divergent Change

You find yourself changing the same module for different reasons.

--

## Problems

* Flexibility: If a module needs to change for many different reasons, you may quickly find that two developers need to
change it at the same time. So the module becomes a bottleneck, slowing down progress.
* Abstraction: Worse, a module with high "churn" may never stabilize, and so may never come to reliably represent a
useful domain abstraction.

--

## What to Do

* If the module has too many (i.e., more than one) responsibilities use [Extract Class](refactoring-ruby#/23) or
[Extract Module](refactoring-ruby#/25) to separate the responsibilities.
* If several classes share the same decisions or variation points, you may be able to consolidate them into new classes
(e.g., by [Hide Delegate](refactoring-ruby#/32), [Pull Up Method](refactoring-ruby#/26), [Form Template Method](#form-template-method),
Extract Superclass or Extract Subclass) or extract a common module to serve as a
mixin. In the limit, these extracted classes or modules can form a layer (e.g., a persistence layer).

---

# Dead Code

A variable, parameter, code fragment, method, module, or class is not used anywhere (perhaps other than in tests)

--

## Problems

* Size: Dead Code adds to the application’s size, and thus to the amount of code that must be understood by developers
and maintainers.
* Communication: It isn’t always obvious when code is dead, and so the reader may take it as having a bearing on the
behavior of his software. Indeed, Dead Code that is also incorrect or invalid may lead the developer seriously
astray.
* Flexibility: All code has dependencies on other code; but Dead Code may create dependencies where otherwise there
would be none. These unnecessary couplings may, in turn, slow the pace of change for the code in these areas.

--

## What to Do

* Delete the unused code and any associated tests.
* The code you just deleted may have been the only client of some other code, so that in turn is now dead. Continue
checking and deleting until you find no more Dead Code.

---

# Lazy Class

* A class isn't doing much its parents, children, or clients seem to be doing all the associated work and there isn’t
enough behavior left in the class to justify its continued existence.

--

## Problems

* Simplicity: Every additional class in the application represents something extra to understand, and extra code to
navigate while following a flow.
* Communication: A Lazy Class also occupies one of the names in your domain space, without paying for that usage.

--

## When to Leave It

Sometimes, a Lazy Class is present to communicate intent. You may have to balance communication versus simplicity in
your design; and when communication wins, leave the Lazy Class in place.

## What to Do

* If parents or children of the class seem like the right place for the class’ behavior, fold it into one of them via
*Collapse Hierarchy*.
* Otherwise, fold its behavior into its caller via [Inline Class](refactoring-ruby#/24).

---

# Temporary Field

An instance variable is set only at certain times, and it is nil (or unused) at other times.

--

## Problems

* Abstraction: Parts of the object change at different rates, and the class spends effort coordinating the changes.
This suggests there is an implicit concept that can be brought out (with its own lifetime).

--

## When to Leave It

It may not be worth the trouble of creating a new class if it doesn’t represent a useful abstraction.

## What to Do

* Use [Extract Class](refactoring-ruby#/23), moving over the fields and any related code.
* Also [Introduce Null Object](refactoring-ruby#/34), [Replace Method with Method Object](refactoring-ruby#/39), [Replace Temp with Query](refactoring-ruby#/40)

---

# Message Chain

You see calls of the form a.b.c.d.

--

## What to Do

* If the manipulations actually belong on the target object (the one at the end of the chain), use [Extract Method](refactoring-ruby#/21) and [Move Method / Move Field](refactoring-ruby#/28) to put them there.
* Use [Hide Delegate](refactoring-ruby#/32) and [Inline Class](refactoring-ruby#/24) to make the caller depend only on
the object at the head of the chain. (So, rather than a.b.c.d, put a d method on the a object. That may require
adding a d method to the b and c objects as well.)

---

## Refactor Me!

You need to refactor the code of [online banking system](https://github.com/dzemlianoi-double/refactoring-example).  
It's really weird and needs some cleaning!

---

## Extract Method

```ruby
class Post
  attr_reader :title, :body, :date

  def initialize(title, body, date)
    @title  = title
    @body   = body
    @date   = date
  end

  def condensed_format
    result = ''
    result << "Title: #{title}"
    result << "Date: #{date.strftime "%Y/%m/%d"}"
    result
  end

  def full_format
    result = ''
    result << "Title: #{title}"
    result << "Date: #{date.strftime "%Y/%m/%d"}"
    result << "--\n#{body}"
    result
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Post
  attr_reader :title, :body, :date

  def initialize(title, body, date)
    @title  = title
    @body   = body
    @date   = date
  end

  def condensed_format
    metadata
  end

  def full_format
    result = metadata
    result << "--\n#{body}"
    result
  end

  private

  def metadata
    result = ''
    result << "Title: #{title}"
    result << "Date: #{date.strftime "%Y/%m/%d"}"
    result
  end
end
```
<!-- .element: class="right width-50" -->

---

## Inline Method

```ruby
class Rating
  def get_rating
    more_than_five_late_deliveries ? 2 : 1
  end

  def more_than_five_late_deliveries
    @number_of_late_deliveries > 5
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Rating
  def get_rating
    @number_of_late_deliveries > 5 ? 2 : 1
  end
end
```
<!-- .element: class="right width-50" -->

---

## Extract Class

```ruby
class Student
  attr_accessor :first_term_assiduity, :first_term_test, :first_term_behavior
  attr_accessor :second_term_assiduity, :second_term_test, :second_term_behavior
  attr_accessor :third_term_assiduity, :third_term_test, :third_term_behavior

  def set_all_grades_to grade
    %w(first second third).each do |which_term|
      %w(assiduity test behavior).each do |criteria|
        send "#{which_term}_term_#{criteria}=".to_sym, grade
      end
    end
  end

  def first_term_grade
    (first_term_assiduity + first_term_test + first_term_behavior) / 3
  end

  def second_term_grade
    (second_term_assiduity + second_term_test + second_term_behavior) / 3
  end

  def third_term_grade
    (third_term_assiduity + third_term_test + third_term_behavior) / 3
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Student
  attr_reader :terms

  def initialize
    @terms = [
      Term.new(:first),
      Term.new(:second),
      Term.new(:third)
    ]
  end

  def set_all_grades_to(grade)
    terms.each { |term| term.set_all_grades_to(grade) }
  end

  def first_term_grade
    term(:first).grade
  end

  def second_term_grade
    term(:second).grade
  end

  def third_term_grade
    term(:third).grade
  end

  def term(reference)
    terms.find { |term| term.name == reference }
  end
end

class Term
  attr_reader :name, :assiduity, :test, :behavior

  def initialize(name)
    @name      = name
    @assiduity = 0
    @test      = 0
    @behavior  = 0
  end

  def set_all_grades_to(grade)
    @assiduity = grade
    @test      = grade
    @behavior  = grade
  end

  def grade
    (assiduity + test + behavior) / 3
  end
end
```
<!-- .element: class="right width-50" -->

---

## Inline Class

```ruby
class Person
  def initialize
    @office_telephone = TelephoneNumber.new
  end

  def telephone_number
    @office_telephone.telephone_number
  end

  def office_telephone
    @office_telephone
  end
end

class TelephoneNumber
  attr_accessor :area_code, :number

  def telephone_number
    '(' + area_code + ') ' + number
  end
end

martin = Person.new
martin.office_telephone.area_code = "781"
```
<!-- .element: class="left width-50" -->

```ruby
class Person
  def initialize
    @office_telephone = TelephoneNumber.new
  end

  def area_code
    @office_telephone.area_code
  end

  def area_code=(arg)
    @office_telephone.area_code = arg
  end

  def number
    @office_telephone.number
  end

  def number=(arg)
    @office_telephone.number = arg
  end
end

class TelephoneNumber
  attr_accessor :area_code, :number

  def telephone_number
    '(' + area_code + ') ' + number
  end
end

martin = Person.new
martin.area_code = "781"
```
<!-- .element: class="right width-50" -->

---

## Extract Module

```ruby
class Bid
  before_save :capture_account_number

  def capture_account_number
    self.account_number = buyer.preferred_account_number
  end
end

class Sale
  before_save :capture_account_number

  def capture_account_number
    self.account_number = buyer.preferred_account_number
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
module AccountNumberCapture
  def self.included(klass)
    klass.class_eval do
      before_save :capture_account_number
    end
  end

  def capture_account_number
    self.account_number = buyer.preferred_account_number
  end
end

class Bid
  include AccountNumberCapture
end

class Sale
  include AccountNumberCapture
end
```
<!-- .element: class="right width-50" -->

---

## Pull Up Method

```ruby
class Person
  attr_reader :first_name, :last_name

  def initialize first_name, last_name
    @first_name = first_name
    @last_name = last_name
  end
end

class MalePerson < Person
  def full_name
    first_name + " " + last_name
  end

  def gender
    "M"
  end
end

class FemalePerson < Person
  def full_name
    first_name + " " + last_name
  end

  def gender
    "F"
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Person
  attr_reader :first_name, :last_name

  def initialize first_name, last_name
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    first_name + " " + last_name
  end
end

class MalePerson < Person
  def gender
    "M"
  end
end

class FemalePerson < Person
  def gender
    "F"
  end
end
```
<!-- .element: class="right width-50" -->

---

## Rename Method

```ruby
class UserService
  USERNAME = "josemota"
  PASSWORD = "secret"

  class << self
    def lgn username, password
      username == USERNAME && password == PASSWORD
    end
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class UserService
  USERNAME = "josemota"
  PASSWORD = "secret"

  class << self
    def sign_in username, password
      username == USERNAME && password == PASSWORD
    end
  end
end
```
<!-- .element: class="right width-50" -->

---

## Move Field

```ruby
PHONE_CODES = {
  en_gb: "44",
  en_us: "541"
}

class Phone
  attr_reader :number

  def initialize number
    @number = number
  end

  def to_s
    number
  end
end

class Person
  attr_reader :locale, :phone

  def initialize(locale: :en_gb, phone: nil)
    @locale = locale
    @phone = Phone.new phone
  end

  def full_phone
    ["+", PHONE_CODES[locale], " ", phone].join
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
PHONE_CODES = {
  en_gb: "44",
  en_us: "541"
}

class Phone
  attr_reader :number, :locale

  def initialize number, locale
    @number = number
    @locale = locale
  end

  def to_s
    PHONE_CODES[locale] + " " + number
  end
end

class Person
  attr_reader :phone

  def initialize(locale: :en_gb, phone: nil)
    @phone = Phone.new phone, locale
  end

  def full_phone
    ["+", phone].join
  end
end
```
<!-- .element: class="right width-50" -->

---

## Form Template Method

```ruby
class Ticket
  attr_reader :price

  def initialize
    @price = 2.0
  end
end

class SeniorTicket < Ticket
  def price
    @price * 0.75
  end
end

class JuniorTicket < Ticket
  def price
    @price * 0.5
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Ticket
  def initialize
    @price = 2.0
  end

  def price
    @price * discount
  end

  def discount
    1
  end
end

class SeniorTicket < Ticket
  def discount
    0.75
  end
end

class JuniorTicket < Ticket
  def discount
    0.5
  end
end
```
<!-- .element: class="right width-50" -->

---

## Parameterize Method

```ruby
class Student
  def first_term_grade
    10
  end

  def second_term_grade
    11
  end

  def third_term_grade
    12
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Student
  GRADES = {
    first: 10,
    second: 11,
    third: 12
  }

  def term_grade index
    GRADES[index]
  end
end
```
<!-- .element: class="right width-50" -->

---

## Separate Query From Modifier

```ruby
class Post
  attr_reader :id, :title, :body, :created_at

  def initialize id, title, body, created_at
    @id         = id
    @title      = title
    @body       = body
    @created_at = created_at
    @published = false
  end

  def self.find id
    # database operation to retrieve data.
    # We will simulate it for now.
    post = POSTS.find { |post| post.id == id }
  end

  def publish
    @published = true
    return POSTS.count { |post| !post.published? }
  end

  def unpublish
    @published = false
  end

  def published?
    @published
  end

end

# Sample data

POSTS = [
  Post.new(
    1,
    "Introduce Null Object Pattern",
    "Post body should be here",
    Time.new(2013,01,25)
  ),
  Post.new(
    2,
    "Introduce Assertion",
    "Post body should be here",
    Time.new(2012,02,26)
  ),
  Post.new(
    3,
    "Extract Method",
    "Post body should be here",
    Time.new(2014,01,27)
  ),
  Post.new(
    4,
    "Replace Type Code with Polymorphism",
    "Post body should be here",
    Time.new(2015,10,12)
  )
]
```
<!-- .element: class="left width-50" -->

```ruby
class Post
  attr_reader :id, :title, :body, :created_at

  def initialize id, title, body, created_at
    @id         = id
    @title      = title
    @body       = body
    @created_at = created_at
    @published = false
  end

  def self.find id
    # database operation to retrieve data.
    # We will simulate it for now.
    post = POSTS.find { |post| post.id == id }
  end

  def self.unpublished
    return POSTS.count { |post| !post.published? }
  end

  def publish
    @published = true
  end

  def unpublish
    @published = false
  end

  def published?
    @published
  end

end

# Sample data

POSTS = [
  Post.new(
    1,
    "Introduce Null Object Pattern",
    "Post body should be here",
    Time.new(2013,01,25)
  ),
  Post.new(
    2,
    "Introduce Assertion",
    "Post body should be here",
    Time.new(2012,02,26)
  ),
  Post.new(
    3,
    "Extract Method",
    "Post body should be here",
    Time.new(2014,01,27)
  ),
  Post.new(
    4,
    "Replace Type Code with Polymorphism",
    "Post body should be here",
    Time.new(2015,10,12)
  )
]
```
<!-- .element: class="right width-50" -->

---

## Hide Delegate

```ruby
class Client
  attr_reader :department, :clerk

  def initialize department, clerk
    @department = department
    @clerk = clerk
  end
end

class Manager
  attr_accessor :department
end

class Clerk
  attr_reader :department

  def initialize(department)
    @department = department
  end

  def manager
    department.manager
  end
end

class Department
  attr_reader :manager

  def initialize manager
    @manager = manager
    manager.department = self
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Client
  attr_reader :clerk

  def initialize clerk
    @clerk = clerk
  end
end

class Clerk
  attr_reader :department

  def initialize (department)
    @department = department
  end

  def manager
    department.manager
  end
end

class Manager
  attr_accessor :department
end

class Department
  attr_reader :manager
  def initialize manager
    @manager = manager
    manager.department = self
  end
end
```
<!-- .element: class="right width-50" -->

---

## Introduce assertion

```ruby
class SquareRootCalculator
  class << self
    def calculate number
      if number > 0
        Math.sqrt number
      end
    end
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
module Assertions
  def assert &block
    raise ArgumentError unless block.call
  end
end

class SquareRootCalculator
  extend Assertions

  def self.calculate number
    assert { number > 0 }
    Math.sqrt number
  end
end
```
<!-- .element: class="right width-50" -->

---

## Introduce Null Object

```ruby
class Post
  attr_reader :id, :title, :body, :created_at

  def initialize(id, title, body, created_at)
    @id         = id
    @title      = title
    @body       = body
    @created_at = created_at
    @published = false
  end

  def self.find_and_publish(id)
    # database operation to retrieve data.
    # We will simulate it for now.
    post = POSTS.find { |post| post.id == id }
    post.publish unless post.nil?
  end

  def publish
    @published = true
  end

end

POSTS = [
  Post.new(
    1,
    "Introduce Null Object Pattern",
    "Post body should be here",
    Time.new(2013,01,25)
  )
]
```
<!-- .element: class="left width-50" -->

```ruby
class Post
  attr_reader :id, :title, :body, :created_at

  def initialize(id, title, body, created_at)
    @id         = id
    @title      = title
    @body       = body
    @created_at = created_at
    @published = false
  end

  def self.find_and_publish(id)
    # database operation to retrieve data.
    # We will simulate it for now.
    post = POSTS.find { |post| post.id == id } || NullPost.new
    post.publish
  end

  def publish
    @published = true
  end
end

class NullPost
  def publish
    # noop
  end
end

POSTS = [
  Post.new(
    1,
    "Introduce Null Object Pattern",
    "Post body should be here",
    Time.new(2013,01,25)
  )
]
```
<!-- .element: class="right width-50" -->

---

## Replace Parameter With Method

```ruby
class CartItem
  def initialize(product, quantity)
    @product  = product
    @quantity = quantity
  end

  def price
    base_price = @quantity * @product.price
    level_of_discount = 1
    level_of_discount = 2 if @quantity > 100
    discounted_price(base_price, level_of_discount)
  end

  def discounted_price(base_price, level_of_discount)
    return base_price * 0.9 if level_of_discount == 2
    base_price * 0.95
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class CartItem
  def initialize(product, quantity)
    @product  = product
    @quantity = quantity
  end

  def price
    base_price * discount_coefficient
  end

  def base_price
    @quantity * @product.price
  end

  def discount_level
    if @quantity > 100
      2
    else
      1
    end
  end

  def discount_coefficient
    if discount_level == 2
      0.9
    else
      0.95
    end
  end
end
```
<!-- .element: class="right width-50" -->

---

## Preserve Whole Object

```ruby
class Room
  def within_plan?(plan)
    low = days_temperature_range.low
    high = days_temperature_range.high
    plan.within_range?(low, high)
  end
end

class HeatingPlan
  def within_range?(low, high)
    (low >= @range.low) && (high <= @range.high)
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Room
  def within_plan?(plan)
    plan.within_range?(days_temperature_range)
  end
end

class HeatingPlan
  def within_range?(room_range)
    (room_range.low >= @range.low) && (room_range.high <= @range.high)
  end
end
```
<!-- .element: class="right width-50" -->

---

## Introduce Parameter Object

```ruby
class Account
  def add_charge(base_price, tax_rate, imported)
    total = base_price + base_price * tax_rate
    total += base_price * 0.1 if imported
    @charges << total
  end

  def total_charge
    @charges.inject(0) { |total, charge| total + charge }
  end
end

account = Account.new
account.add_charge(5, 0.1, true)
account.add_charge(12, 0.125, false)
total = account.total_charge
```
<!-- .element: class="left width-50" -->

```ruby
class Account
  def add_charge(charge)
    @charges << charge
  end

  def total_charge
    @charges.inject(0) do |total_for_account, charge|
      total_for_account + charge.total
    end
  end
end

class Charge
  def initialize(base_price, tax_rate, imported)
    @base_price = base_price
    @tax_rate = tax_rate
    @imported = imported
  end

  def total
    result = @base_price + @base_price * @tax_rate
    result += @base_price * 0.1 if @imported
    result
  end
end

account = Account.new
account.add_charge(Charge.new(9.0, 0.1, true))
account.add_charge(Charge.new(12.0, 0.125, true))
total = account.total_charge
```
<!-- .element: class="right width-50" -->

---

## Replace Array With Object

```ruby
class Cart
  attr_reader :products

  def initialize(products)
    @products = products
  end

  def total
    products.inject(0) { |sum, product| sum + product[2] }
  end
end

Cart.new([
  [ "Sweater"   , "Pink" , 5.0  ],
  [ "Trousers"  , "Blue" , 8.0  ],
  [ "Golf Club" , "Gray" , 12.0 ]
]).total
```
<!-- .element: class="left width-50" -->

```ruby
class Cart
  attr_reader :products

  def initialize(products)
    @products = products.map { |product| Product.new *product }
  end

  def total
    products.inject(0) { |sum, product| sum + product.price }
  end

end

class Product
  attr_reader :name, :color, :price

  def initialize(name, color, price)
    @name  = name
    @color = color
    @price = price
  end
end

Cart.new([
  [ "Sweater"   , "Pink" , 5.0  ],
  [ "Trousers"  , "Blue" , 8.0  ],
  [ "Golf Club" , "Gray" , 12.0 ]
]).total
```
<!-- .element: class="right width-50" -->

---

## Replace Method With Method Object

```ruby
class Person
  def tax(income: nil, expenses: 0, type: :dependent_worker)
    return_value = 0
    number_of_people_under_roof = 1

    if type == :dependent_worker
      return_value += income * 0.02
    else
      return_value += income * 0.04
    end

    if number_of_people_under_roof > 2
      return_value *= 1.10
    end

    if income - expenses > income * 0.05
      return_value += expenses * 0.05
    end

    return_value -= expenses * 0.30
  end
end
```
<!-- .element: class="left width-50" -->


```ruby
class TaxAlgorithm
  def initialize(income: nil, expenses: 0, type: :dependent_worker)
    @income   = income
    @expenses = expenses
    @type     = type
    @return_value = 0
    @number_of_people_under_roof = 1
  end

  def compute
    process_type
    process_number_of_people
    process_income_expense_difference
    deduct_expenses
  end

  def process_type
    if @type == :dependent_worker
      @return_value += @income * 0.02
    else
      @return_value += @income * 0.04
    end
  end

  def process_number_of_people
    @return_value *= 1.10 if @number_of_people_under_roof > 2
  end

  def process_income_expense_difference
    @return_value += @expenses * 0.05 if @income - @expenses > @income * 0.05
  end

  def deduct_expenses
    @return_value -= @expenses * 0.30
  end
end

class Person
  def tax(income: nil, expenses: 0, type: :dependent_worker)
    TaxAlgorithm.new(income: income, expenses: expenses, type: type).compute
  end
end
```
<!-- .element: class="right width-50" -->

---

## Replace Temp With Query

```ruby
class Cuboid
  attr_reader :length, :width, :height

  def initialize(length, width, height)
    @length = length
    @width  = width
    @height = height
  end

  def volume
    area = length * width
    area * height
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Cuboid
  attr_reader :length, :width, :height

  def initialize(length, width, height)
    @length = length
    @width  = width
    @height = height
  end

  def volume
    area * height
  end

  def area
    length * width
  end
end
```
<!-- .element: class="right width-50" -->

---

## Replace Type Code With Polymorphism

```ruby
class Employee
  def initialize(type: :regular)
    @type = type
  end

  def base_salary
    500.0
  end

  def salary
    base_salary + bonus
  end

  def self.build(type: :regular)
    new type: type
  end

  private

  def bonus
    value = case @type
      when :regular then 0
      when :boss    then 1500.0
      when :manager then 800.0
    end
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Employee
  def initialize(type: :regular)
    @type = type
  end

  def base_salary
    500.0
  end

  def salary
    base_salary + bonus
  end

  def self.build(type: :employee)
    const_get(type.capitalize).new
  end

  def bonus
    0
  end
end

class Manager < Employee
  def bonus
    800
  end
end

class Boss < Employee
  def bonus
    1500
  end
end
```
<!-- .element: class="right width-50" -->

---

## Replace Type Code With Module Extension

```ruby
class Employee
  def initialize(type: :regular)
    @type = type
  end

  def base_salary
    500.0
  end

  def salary
    base_salary + bonus
  end

  private

  def self.build(type: :regular)
    new type: type
  end

  def bonus
    value = case @type
      when :regular then 0
      when :boss    then 1500.0
      when :manager then 800.0
    end
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class Employee
  def initialize(type: :regular)
    @type = type
  end

  def base_salary
    500.0
  end

  def salary
    base_salary + bonus
  end

  def self.build(type: :regular)
    instance = new
    instance.extend const_get(type.capitalize)
  end

end

module Regular
  def bonus
    0
  end
end

module Manager
  def bonus
    800
  end
end

module Boss
  def bonus
    1500
  end
end
```
<!-- .element: class="right width-50" -->

---

## Replace Type Code With State Strategy

```ruby
class User
  attr_reader :name, :type, :options

  def initialize(name, type, options = {})
    @name    = name
    @type    = type
    @options = options
  end

  def public_key_matches?
    # Do some logic
    true
  end

  def oauth_authenticates?
    # Do some logic
    true
  end

  class << self
    def login(name, options = {})
      user = USERS.find { |u| u.name == name }

      case user.type
        when :password
          return user.options[:password] == options[:password]
        when :public_key
          return user.public_key_matches?
        when :oauth
          return user.oauth_authenticates?
      end
    end
  end
end
```
<!-- .element: class="left width-50" -->

```ruby
class User
  attr_reader :name, :type, :options

  def initialize(name, type, options = {})
    @name    = name
    @type    = type
    @options = options

    @strategy = case @type
      when :password
        Auth::Password.new self
      when :public_key
        Auth::PublicKey.new self
      when :oauth
        Auth::OAuth.new self
    end
  end

  def auth! options
    @strategy.auth? options
  end

  class << self
    def login(name, options = {})
      user = USERS.find { |u| u.name == name }

      user.auth! options
    end
  end
end

module Auth
  class Password
    def initialize user
      @user = user
    end

    def auth? options
      @user.options[:password] == options[:password]
    end
  end

  class PublicKey
    def initialize user
      @user = user
    end

    def auth? options
      # Do some logic
      true
    end
  end

  class OAuth
    def initialize user
      @user = user
    end

    def auth? options
      # Do some logic
      true
    end

  end
end
```
<!-- .element: class="right width-50" -->

---

## Substitute Algorithm

```ruby
def found_friends(people)
  friends = []
  people.each do |person|
    if(person == "Don")
      friends << "Don"
    end

    if(person == "John")
      friends << "John"
    end

    if(person == "Kent")
      friends << "Kent"
    end
  end
  friends
end
```
<!-- .element: class="left width-50" -->

```ruby
def found_friends(people)
  people.select do |person|
    %w(Don John Kent).include? person
  end
end
```
<!-- .element: class="right width-50" -->

---

## Decompose conditional

```ruby
if date < SUMMER_START || date > SUMMER_END
  charge = quantity * @winter_rate + @winter_service_charge
else
  charge = quantity * @summer_rate
end
```
<!-- .element: class="left width-50" -->

```ruby
def final_charge
  unless summer?(date)
    winter_charge(quantity)
  else
    summer_charge(quantity)
  end
end

def summer?(date)
  date >= SUMMER_START && date <= SUMMER_END
end

def winter_charge(quantity)
  quantity * @winter_rate + @winter_service_charge
end

def summer_charge(quantity)
  quantity * @summer_rate
end
```
<!-- .element: class="right width-50" -->

---

## Replace Loop with Collection Closure Method

```ruby
managers = []
employees.each do |e|
  managers << e if e.manager?
end

offices = []
employees.each { |e| offices << e.office }

manager_offices = []
employees.each do |e|
  manager_offices << e.office if e.manager?
end
```

```ruby
managers = employees.select { |e| e.manager? }

offices = employees.collect { |e| e.office }

manager_offices = employees.select { |e| e.manager? }.collect { |e| e.office }
```

---

## Introduce Named Parameter

```ruby
class SearchCriteria
  def initialize(title = nil, author_id = nil, publisher_id = nil)
    @title = title
    @author_id = author_id
    @publisher_id = publisher_id
  end
end

criteria = SearchCriteria.new("Metaprogramming Ruby", 5, 8)
```

```ruby
class SearchCriteria
  def initialize(title: nil, author_id: nil, publisher_id: nil)
    @title = title
    @author_id = author_id
    @publisher_id = publisher_id
  end
end

criteria = SearchCriteria.new(title: "Metaprogramming Ruby", author_id: 5)
```

---

# The End
