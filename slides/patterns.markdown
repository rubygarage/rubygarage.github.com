---
layout: slide
title:  Patterns
---

# Patterns

---

# Patterns

It's a general repeatable solution to a commonly occurring problem in software development.

---

## Patterns benefits

- Proven Solutions
<!-- .element: class="fragment" -->
<br>
_Don't invent the second bicycle! Just modify and use on of the well known patterns._
<br>
<br>
- Code standartization
<!-- .element: class="fragment" -->
<br>
 _When certain problems are solved with certain approaches it makes your code easy to maintain and also protects you from unexpected and hidden errors, cause you use standard unified solutions._
<br>
<br>
- General Programming Dictionary
<!-- .element: class="fragment" -->
<br>
 _It's the easiest way to say the name of the pattern, instead of an hour explaining to other programmers what cool design you have come up with._

---

## Patterns basic classification

* **Idioms** - low level patterns that are suitable just for specific language. They usually describe abilities or rules of the language and some conventions between developers of this language.
<br>
<br>
* **Design Patterns** - medium-scale patterns to organize subsystem functionality in application domain independent way
<br>
<br>
* **Architectural Patterns** - high level patterns to help to specify the fundamental structure of a software system

---
## Design patterns types
<br>
* Creational patterns
* Structural patterns
* Behavioral patterns

---
## Creational patterns
<br>
Creational design patterns are responsible for efficient object creation mechanisms,
which increase the flexibility and reuse of existing code.

--

# Factory Method

--

## Factory Method

Factory Method is a creational design pattern that provides an interface for creating objects in superclass, but allow subclasses to alter the type of objects that will be created.

--

## Problems
* The Factory Method pattern comes into play when you need to pick the right class.

--

## Solutions

* The Factory Method pattern suggests moving direct object creation to the subclass. Objects returned by factory methods are often referred to as "products."

--

## Example without pattern

```ruby
Need to implement
```

--

## Example with pattern

```ruby
Need to implement
```

--

## Pros and Cons

**+** Follows the Open/Closed Principle.<br><br>
**+** Simplifies code due to moving all creational code to one place.<br><br>
**+** Simplifies adding new products to the program.<br><br>


<!-- .element: class="text-left left width-50" -->

**-** Requires extra subclasses.<br><br>

<!-- .element: class="text-left right width-50" -->

--

# Builder

--

## Builder

Builder is a creational design pattern that lets you produce different types and representations of an object using the same building process. Builder allows constructing complex objects step by step.

--

## Problems
* Imagine a complex object that requires laborious step by step initialization of many fields and nested objects. Such code is usually buried inside a constructor with lots of parameters, or worse, scattered all over the client code.

--

## Solutions

* The Builder pattern suggests to extract the object construction code out of its own class and move it to separate objects called builders.

--

## Example without pattern

```ruby
Need to implement
```

--

## Example with pattern

```ruby
Need to implement
```

--

## Pros and Cons

**+** Allows building products step by step.<br><br>
**+** Allows using the same code for building different products.<br><br>
**+** Isolates the complex construction code from a product's core business logic.<br><br>


<!-- .element: class="text-left left width-50" -->

**-** Increases overall code complexity by creating multiple additional classes.<br><br>

<!-- .element: class="text-left right width-50" -->

--

# Singleton

--

## Singleton
<br>
**Singleton** is a creational design pattern that lets you ensure that a class has only one instance
and provide a global access point to this instance.

--

## Problems
* Duplication the quantity of class instances in different parts of a code while just one instance is sufficient for use
* Code which solves the previous problem scattered all over your program.

--

## Solutions

* Making the default initialize method private.
* Creating a static creation method that will act as a constructor. This method creates an object using the private "**new**" and saves it in class variable. All following calls to this method return the cached object.
--

## Example without pattern

logger.rb <!-- .element: class="filename" -->
```ruby
class Logger
  def initialize
    @log = File.open("log.txt", "a")
  end

  def warn(msg)
    @log.puts(msg)
  end
end
```
--

## Example without pattern

```ruby
class Oven
  MAX_TIME_SECONDS = 10

  def check_oven
    Logger.new.warn('Its too hot. Turn it off!') if max_cook_time_expired?
  end

  def on
    @start_time = Time.now
  end

  private

  def max_cook_time_expired?
    Time.now.to_i - @start_time.to_i > MAX_TIME_SECONDS
  end
end
```
<!-- .element: class="left width-50" -->


```ruby
class Bath
  LITERS_PER_SEC = 0.7
  MAX_VOLUME_LITERS = 6

  def check_bath
    Logger.new.warn('Too much water. Turn it off!') if bath_full?
  end

  def on
    @start_time = Time.now
  end

  private

  def time_passed
    Time.now.to_i - @start_time.to_i
  end

  def bath_full?
    time_passed * LITERS_PER_SEC > MAX_VOLUME
  end
end
```
<!-- .element: class="right width-50" -->

--

## Example with pattern

```ruby
class Logger
  def initialize
    @log = File.open("log.txt", "a")
  end

  @@instance = Logger.new

  def self.instance
    return @@instance
  end

  def warn(msg)
    @log.puts(msg)
  end

  private_class_method :new
end
```

--

## Example with pattern

```ruby
class Oven
  # The same code

  def check_oven
    Logger.instance.warn('Its too hot. Turn it off!') if max_cook_time_expired?
  end

  # The same code
end
```

```ruby
class Bath
  # The same code

  def check_bath
    Logger.instance.warn('Too much water. Turn it off!') if bath_full?
  end

  # The same code
end
```
--

## Pros and Cons

**+** Ensures that class has only a single instance.<br><br>
**+** Provides global access point to that instance.<br><br>
**+** Allows deferred initialization.

<!-- .element: class="text-left left width-50" -->

**-** Violates Single Responsibility Principle.<br><br>
**-** Masks bad design.<br><br>
**-** Requires endless mocking in unit tests.

<!-- .element: class="text-left right width-50" -->

---


## Structural patterns

Structural design patterns are responsible for building simple and efficient class hierarchies and relations between different classes.

--

# Facade

--

## Facade

Facade is a structural design pattern that lets you provide a simplified interface<br>
to a complex system of classes, library or framework.

--

## Problems
* For creating some complex action you need to call many small(or not) methods of different classes
* Quantity of dependencies between client and hard system(complex of subsystems) are too huge.
* Business logic of your classes becomes tightly coupled to the implementation details of third party libraries

--

## Solutions

* Creating class that provides a simple interface to a complex subsystem containing dozens of classes

--

## Example without pattern

```ruby
class UsersController < ApplicationController
  def index
    @user = User.new
    @last_active_users = User.active.order(created_at: :desc).limit(10)
    @vip_users_presenter = VipUsersPresenter.new(User.active.vip)
    @messages = current_user.messages
  end
end
```

--

## Example with pattern

```ruby
class UsersFacade
  attr_reader :current_user, :vip_presenter

  def initialize(current_user, vip_presenter = VipUsersPresenter)
    @current_user = current_user
    @vip_presenter = vip_presenter
  end

  def new_user
    User.new
  end

  def last_active_users
    @last_active_users ||= active_users.order(created_at: :desc).limit(10)
  end

  def vip_users
    @vip_users ||= vip_presenter.new(active_users.vip).users
  end

  def messages
    @messages ||= current_user.messages
  end

  private

  def active_users
    User.active
  end
end
```
--

## Example with pattern

```ruby
class UsersController < ApplicationController
  def index
    @user_facade = UsersFacade.new(current_user)
  end
end
```

--

## Pros and Cons

**+** Isolates clients from subsystem components.<br><br>
**+** Minimizes coupling between client code and subsystem.Ensures that class has only a single instance.<br><br>
**+** Maintain the "thinness" of classes that should be "thin".

<!-- .element: class="text-left left width-50" -->

**-** Facade risks becoming a **god** object, coupled to all application classes.<br><br>
**-** Introducing facades in your project means new abstraction layer.

<!-- .element: class="text-left right width-50" -->

--

# Adapter

--

## Adapter

Adapter is a structural design pattern that allows objects with incompatible interfaces to collaborate.

--

## Problems
* The interface we have is different from the interface we need

--

## Solutions

* Create a special object that converts calls sent by one object to the format<br/>
that another object can understand

--

## Example without pattern

```ruby
class WeatherMailer < ApplicationMailer
  def forecast_email(weather_object)
    temperature = weather_object.temperature_c
    wind_speed = weather_object.wind_speed_km_h
    humidity = weather_object.humidity

    # email the forecast ...
  end
end

class WeatherObject
  attr_reader :temperature_c, :wind_speed_km_h, :humidity

  def initialize(temperature_c, wind_speed_km_h, humidity)
    @temperature_c = temperature_c
    @wind_speed_km_h = wind_speed_km_h
    @humidity = humidity
  end
end

class UsaWeatherObject
  attr_reader :temperature_f, :wind_speed_mi_h, :moisture

  # ...
end
```

--

## Example with pattern

```ruby
class UsaWeatherObjectAdapter < WeatherObject
  def initialize(usa_weather_object)
    @usa_weather_object = usa_weather_object
  end

  def temperature_c
    (@usa_weather_object.temperature_f - 32) / 1.8
  end

  def wind_speed_km_h
    @usa_weather_object.wind_speed_mi_h / 1.6
  end

  def humidity
    @usa_weather_object.moisture
  end
end

usa_weather_object = UsaWeatherObject.new(36, 10, 70)

WeatherMailer.new.forecast_email(UsaWeatherObjectAdapter.new(usa_weather_object)).deliver_later
```

--

## Pros and Cons

**+** Hides from the client code unnecessary implementation details of interface & data conversion.<br><br>

<!-- .element: class="text-left left width-50" -->

**-** Increases overall code complexity by creating additional classes.<br><br>

<!-- .element: class="text-left right width-50" -->

--

# Decorator

--

## Decorator

Decorator is a structural design pattern that lets you attach new behaviors to objects by placing them inside wrapper objects that contain these behaviors.

--

## Problems
* You need to vary the responsibilities of an object. Sometimes your object needs to do a little more, but sometimes a little less.

--

## Solutions

* The decorator pattern relies on special objects called decorators (or wrappers).<br/>
When you call a decorator's method, it executes the same method in a wrapped object and then adds something to the result.

--

## Example without pattern

```ruby
class User < ApplicationRecord
  has_many :posts
  validates :name, :email, presence: true

  def commented_posts
    posts.joins(:comments).group('posts.id').having('count(comments) > 0')
  end

  def profile_icon
    "<div class='user-icon'><p>#{initials}</p></div>".html_safe
  end

  private

  def initials
    first_name, last_name = name.split(' ')
    (first_name[0] + last_name[0]).upcase
  end
end

User.first.profile_icon
```

--

## Example with pattern

```ruby
class User < ApplicationRecord
  has_many :posts
  validates :name, :email, presence: true

  def commented_posts
    posts.joins(:comments).group('posts.id').having('count(comments) > 0')
  end
end

class UserDecorator
  def initialize(real_user)
    @real_user = real_user
  end

  def commented_posts
    @real_user.commented_posts
  end
end

class UserProfileDecorator < UserDecorator
  def initialize(real_user)
    super(real_user)
  end

  def profile_icon
    "<div class='user-icon'><p>#{initials}</p></div>".html_safe
  end

  private

  def initials
    first_name, last_name = name.split(' ')
    (first_name[0] + last_name[0]).upcase
  end
end

UserProfileDecorator.new(User.first)).profile_icon
```

--

## Pros and Cons

**+** Allows adding and removing behaviors at runtime.<br><br>
**+** Allows combining several additional behaviors by using multiple wrappers.<br><br>
**+** Allows composing complex objects from simple ones instead of having monolithic classes that implement every variant of behavior.<br><br>


<!-- .element: class="text-left left width-50" -->

**-** Lots of small classes.<br><br>
**-** It is hard to configure a multi-wrapped object.<br><br>

<!-- .element: class="text-left right width-50" -->

---

## Behavioral

Behavioral patterns are responsible for the efficient and safe distribution of behaviors among the program's objects.

--

# Strategy

--

## Strategy

**Strategy** is a behavioral design pattern that lets you define a family of algorithms, encapsulate each one, and make them interchangeable.
<br><br>
**Strategy** lets the algorithm vary independently from the clients that use it.

--

## Problems

* Any change of feature algorithms, such as fixing a bug or slightly tuning the algorithm's behavior, affected the whole class, where they placed.
* Increasing the number of feature algorithms stacking into the base class and that class becomes a "god" one.

--

## Solutions

* Define set of classes (strategies) which solve the same problem in different way, depending on conditions.
* A class delegates an algorithm to a strategy object at run-time instead of implementing an algorithm directly.

--

## Example without pattern

```ruby
class Worker
  FACTORY_SOCIAL_TAX = 0.3
  FACTORY_UNION_TAX = 313
  BANK_COUNTRY_NATIONAL_TAX = 0.1
  BANK_PENSION_TAX = 0.1
  BANK_MIN_SALARY_VARIATION = 0.05
  ARMY_COUNTRY_STATE_TAX = 0.25
  ARMY_TAX = 1200
  MINIMAL_AMOUNT = {
    factory: 3_373,
    bank: 12_000,
    army:  19_000
  }

  def salary(amount, bonus, job_type)
    @amount = amount
    @bonus = bonus
    case job_type
    when :factory then factory_salary
    when :bank then bank_salary
    when :army then army_salary      
    else raise 'Undefined country!'
    end
  end

  def factory_salary
    raise 'Minimal Amount Error' if @amount + @bonus < MINIMAL_AMOUNT[:factory]
    bonus_after_tax = @bonus > @amount * FACTORY_SOCIAL_TAX ? bonus * FACTORY_SOCIAL_TAX : @bonus
    @amount * (1 - FACTORY_SOCIAL_TAX) - FACTORY_UNION_TAX + bonus_after_tax
  end

  def bank_salary
    raise 'Minimal Amount Error' if @amount + BANK_MIN_SALARY_VARIATION < MINIMAL_AMOUNT[:bank]
    (@amount + @bonus) * (1 - BANK_COUNTRY_NATIONAL_TAX) + @amount * (1 - BANK_PENSION_TAX)
  end

  def army_salary
    raise 'Minimal Amount Error' if @amount < MINIMAL_AMOUNT[:army]
    @amount * (1 - ARMY_COUNTRY_STATE_TAX) - ARMY_TAX + @bonus
  end  
end
```
--

## Example with pattern

```ruby
class Worker
  def salary(amount, bonus, job_type)
    case job_type
    when :factory then FactoryStrategy.new(amount, bonus).salary
    when :bank then BankStrategy.new(amount, bonus).salary
    when :army then ArmyStrategy.new(amount, bonus).salary     
    else raise 'Undefined job type!'
    end
  end
end
```

```ruby
class JobStrategy
  def initialize(amount, bonus)
    @amount = amount
    @bonus = bonus
  end  
end
```

--
## Example with pattern

```ruby
class FactoryStrategy > JobStrategy
  SOCIAL_TAX = 0.3
  UNION_TAX = 313
  MINIMAL_AMOUNT = 3_373

  def salary
    raise 'Minimal Amount Error' if amount_lower_than_minimal?
    taxed_amount - UNION_TAX + bonus_after_tax
  end

  private

  def amount_lower_than_minimal?
    @amount + @bonus < MINIMAL_AMOUNT
  end  

  def bonus_after_tax
    @bonus > taxed_amount ? @bonus * SOCIAL_TAX : @bonus
  end  

  def taxed_amount
    @amount * (1 - SOCIAL_TAX)
  end  
end
```

--
## Example with pattern

```ruby
class BankStrategy
  COUNTRY_NATIONAL_TAX = 0.1
  PENSION_TAX = 0.1
  MIN_SALARY_VARIATION = 0.05
  MINIMAL_AMOUNT = 12_000

  def salary
    raise 'Minimal Amount Error' if amount_lower_than_minimal?
    national_taxed_amount + pension_taxed_amount
  end  

  private

  def national_taxed_amount
    (@amount + @bonus) * (1 - COUNTRY_NATIONAL_TAX)
  end

  def pension_taxed_amount
    @amount * (1 - PENSION_TAX)
  end    

  def amount_lower_than_minimal?
    @amount + MIN_SALARY_VARIATION < MINIMAL_AMOUNT
  end  
end    
```

--
## Example with pattern

```ruby
class ArmyStrategy
  COUNTRY_STATE_TAX = 0.25
  ARMY_TAX = 1200
  MINIMAL_AMOUNT = 19_000

  def salary
    raise 'Minimal Amount Error' if amount_lower_than_minimal?
    state_taxed_amount - ARMY_TAX + @bonus
  end

  private

  def amount_lower_than_minimal?
    @amount < MINIMAL_AMOUNT
  end

  def state_taxed_amount
    @amount * (1 - COUNTRY_STATE_TAX)
  end     
end
```

--

## Pros and Cons

**+** Allows hot swapping algorithms at runtime.<br><br>
**+** Isolates the code and data of the algorithms from the other classes.<br><br>
**+** Replaces inheritance with delegation.<br><br>
**+** Follows the Open/Closed Principle.

<!-- .element: class="text-left left width-50" -->

**-** Increases overall code complexity by creating multiple additional classes.<br><br>
**-** Client must be aware of the differences between strategies to pick a proper one.

<!-- .element: class="text-left right width-50" -->

--

# Chain of Responsibility

--

## Chain of Responsibility

Chain of Responsibility is a behavioral design pattern that lets you avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request.<br><br>

Chain the receiving objects and pass the request along the chain until an object handles it.

--

## Problems

* Needless coupling between senders of requests and their receivers
* Just one receiver can handle a request

--

## Solutions

* Define a chain of receiver objects having the responsibility, depending on run-time conditions, to either handle a request or forward it to the next receiver on the chain

--

## Example without pattern

```ruby

class WebManager
  def deliver_application
    Designer.new.design_interface
    Developer.new.build_application
    Copywriter.new.write_documentation
    Developer.new.deploy_application
    puts "#{self.class.to_s}: Application delivered"
  end
end  

```

--

## Example with pattern

```ruby
module Chainable
  def next_in_chain(link)
    @next = link
  end

  def method_missing(method, *args, &block)
    return if @next == nil
    @next.public_send(method, *args, &block)
  end
end  
```

```ruby
class Worker
  include Chainable

  def initialize(link = nil)
    next_in_chain(link)
  end
end  
```

```ruby
class WebManager > Worker
  def deliver_application
    design_interface
    build_application
    write_documentation
    deploy_application
    puts "#{self.class.to_s}: Application delivered"
  end
end
```

--

## Example with pattern

```ruby

class WebDeveloper > Worker
  def build_application
    puts "#{self.class.to_s}: I'm building the application"
  end

  def deploy_application
    puts "#{self.class.to_s}: I'm deploying the application"
  end
end
```

```ruby

class WebDesigner > Worker
  def design_interface
    puts "#{self.class.to_s}: I'm designing the interface"
  end
end
```

```ruby

class Copywriter
  def write_documentation
    puts "#{self.class.to_s}: I'm writing the documentation"
  end
end

```

--

# Pros and Cons

**+** Reduces coupling between senders of requests and their receivers.<br></br>
**+** Follows the Single Responsibility Principle.<br></br>
**+** Follows the Open/Closed Principle.<br></br>

<!-- .element: class="text-left left width-50" -->

**-** Some requests may end up unhandled.

<!-- .element: class="text-left right width-50" -->
--

# Observer

--

## Observer

Observer is a behavioral design pattern that lets you define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

--

## Problems
* Some components (subscribers) should know about the activities of other components (publishers)

--

## Solutions

* The Observer pattern provides the publisher with a list of the subscribers, interested in tracking its state. The list can be modified via several subscription methods available to subscribers. Thus, each subscriber is able to add or remove itself from the list whenever it wants.

--

## Example without pattern

```ruby
class Organization
  attr_reader :name, :motto, :employees

  def initialize(name, motto, hr_department, financial_department, employees = [])
    @name = name
    @motto = motto
    @employees = employees
    @hr_department = hr_department
    @financial_department = financial_department
  end

  def add_employee(employee)
    @employees << employee
    @hr_department.notify(self)
    @financial_department.notify(self)
  end
end

hr_department = HrDepartment.new
financial_department = FinancialDepartment.new

organization = Organization.new('Apple', 'Think Different', hr_department, financial_department)
employee = Emplee.new('David', 'Holland')

organization.add_employee(employee)
```

--

## Example with pattern

```ruby
module Observable
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_ovserver(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.notify(self)
    end
  end
end

class Organization
  include Observable

  attr_reader :name, :motto, :employees

  def initialize(name, motto, employees = [])
    super()
    @name = name
    @motto = motto
    @employees = employees
  end

  def add_employee(employee)
    @employees << employee
    notify_observers(self)
  end
end

hr_department = HrDepartment.new
financial_department = FinancialDepartment.new

organization = Organization.new('Apple', 'Think Different')

organization.add_observer(hr_department)
organization.add_observer(financial_department)

employee = Emplee.new('David', 'Holland')

organization.add_employee(employee)
```

--

## Pros and Cons

**+** Publisher is not coupled to concrete subscriber classes.<br><br>
**+** You can subscribe and unsubscribe objects dynamically.<br><br>
**+** Follows the Open/Closed Principle.<br><br>


<!-- .element: class="text-left left width-50" -->

**-** Subscribers are notified in random order.<br><br>

<!-- .element: class="text-left right width-50" -->

---

## Common misconceptions
- Design pattern is a finished design that can be transformed directly into code<br>
_Design patterns is just an approach for code designing. It doesn't have certain code base._
<br><br>

- You can choose just one pattern for problem solving/task completing<br>
_Exactly not. Most of patterns have "partner-patterns" that can help you to make the solution more scalable or/and structured._
<br><br>

- You should use certain pattern for certain problem<br>
_Pattern choosing depends not just on the task or problem, but on other important things like: common architecture of the app, business component vector of the app, and other_
