---
layout: slide
title:  Refactoring in Rails
---

# Refactoring.

> When you work on a big project, you’re pushed to deliver new features. The business rarely understands the reasons for
refactoring.

> Refactoring is an ongoing activity. Refactoring is a team activity. Refactoring is best when everyone understands the
reasons and agrees on the direction of the code changes.

---

# DRY

### Don't repeat yourself

---

# KISS

### Keep it simple, stupid

---

# SOLID principles

![](/assets/images/solid.jpg)

---

## Inline controller filters

> Using controller filters is a very popular approach in Rails apps. This technique is used for implementing
cross-cutting concerns, like authorization, auditing and data loading.

> Often, the filters introduce coupling between the controller action and the result of the filters. Sometimes the
coupling doesn’t hurt much. Sometimes, though, the filters prepare some global state using the instance variables. That
makes the coupling worse, as it’s difficult to extract a service object from a controller.

--

### Example

```ruby
class TimelogController < ApplicationController
  before_action :find_project_for_new_time_entry, only: [:create]

  def create
    @time_entry ||= TimeEntry.new(project: @project,
                                  issue: @issue,
                                  user: User.current,
                                  spent_on: User.current.today)

    @time_entry.safe_attributes = params[:time_entry]

    call_hook(:controller_timelog_edit_before_save, { params: params, time_entry: @time_entry })

    if @time_entry.save respond_to do |format|
      format.html do
        # ...
      end
    end
  end

  private

  def find_project_for_new_time_entry
    find_optional_project_for_new_time_entry

    if @project.nil?
      render_404
    end
  end

  def find_optional_project_for_new_time_entry
    # ...
  end
end
```

--

### Refactoring

```ruby
class TimelogController < ApplicationController
  def create
    find_project_for_new_time_entry

    @time_entry ||= TimeEntry.new(project: @project,
                                  issue: @issue,
                                  user: User.current,
                                  spent_on: User.current.today)

    @time_entry.safe_attributes = params[:time_entry]

    call_hook(:controller_timelog_edit_before_save, { params: params, time_entry: @time_entry })

    if @time_entry.save respond_to do |format|
      format.html do
        # ...
      end
    end
  end

  private

  def find_project_for_new_time_entry
    find_optional_project_for_new_time_entry

    if @project.nil?
      render_404
    end
  end

  def find_optional_project_for_new_time_entry
    # ...
  end
end
```

---

## Split controllers

### Example

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :users do
  member do
    get :following, :followers
  end
end
```

app/controllers/users_controller.rb <!-- .element: class="filename" -->

```ruby
class UsersController < ApplicationController
  # ...
  def following
    @presenter = Users::FollowedUsersPresenter.new(params[:id], params[:page])
  end

  def followers
    @presenter = Users::FollowersPresenter.new(params[:id], params[:page])
  end
  # ...
end
```

--

### Refactoring

config/routes.rb <!-- .element: class="filename" -->

```ruby
resources :users do
  member do
    get :followers, controller: 'followers'
    get :following, controller: 'following'
  end
end
```

app/controllers/followers_controller.rb <!-- .element: class="filename" -->

```ruby
class FollowersController < ApplicationController
  before_action :signed_in_user

  def followers
    @presenter = Users::FollowersPresenter.new(params[:id], params[:page])
    render '/users/followers'
  end
end
```

app/controllers/following_controller.rb <!-- .element: class="filename" -->

```ruby
class FollowingController < ApplicationController
  before_action :signed_in_user

  def following
    @presenter = Users::FollowedUsersPresenter.new(params[:id], params[:page])
    render '/users/following'
  end
end
```

---

## Controller concerns

### Example

app/controllers/followers_controller.rb <!-- .element: class="filename" -->

```ruby
class FollowersController < ApplicationController
  before_action :signed_in_user

  def followers
    @presenter = Users::FollowersPresenter.new(params[:id], params[:page])
    render '/users/followers'
  end
end
```

app/controllers/following_controller.rb <!-- .element: class="filename" -->

```ruby
class FollowingController < ApplicationController
  before_action :signed_in_user

  def following
    @presenter = Users::FollowedUsersPresenter.new(params[:id], params[:page])
    render '/users/following'
  end
end
```

--

### Refactoring

app/controllers/concerns/signed_in_user.rb <!-- .element: class="filename" -->

```ruby
module SignedInUser
  extend ActiveSupport::Concern

  included do
    before_action :signed_in_user
  end
end
```

app/controllers/followers_controller.rb <!-- .element: class="filename" -->

```ruby
class FollowersController < ApplicationController
  include SignedInUser

  def followers
    @presenter = Users::FollowersPresenter.new(params[:id], params[:page])
    render '/users/followers'
  end
end
```

app/controllers/following_controller.rb <!-- .element: class="filename" -->

```ruby
class FollowingController < ApplicationController
  include SignedInUser

  def following
    @presenter = Users::FollowedUsersPresenter.new(params[:id], params[:page])
    render '/users/following'
  end
end
```

---

## Service objects

> Services are not the silver bullet. They don’t solve all the problems. They are good as the first step into the process of improving the design of your application.

--

### Bryan Helmkamp

Some actions in a system warrant a Service Object to encapsulate their operation. I reach for Service Objects when an
action meets one or more of these criteria:

* The action is complex (e.g. closing the books at the end of an accounting period)
* The action reaches across multiple models (e.g. an e-commerce purchase using Order, CreditCard and Customer objects)
* The action interacts with an external service (e.g. posting to social networks)
* The action is not a core concern of the underlying model (e.g. sweeping up outdated data after a certain time period)
* There are multiple ways of performing the action (e.g. authenticating with an access token or password). This is the Gang of Four Strategy pattern

--

### Eric Evans

Service: A standalone operation within the context of your domain. A Service Object collects one or more services
into an object. Typically you will have only one instance of each service object type within your execution context.

--

### Andrzej Krzywda

* Isolate from the Rails HTTP-related parts
* Faster build time
* Easier testing
* Easier reuse for API
* Less coupling
* Thinner controllers

---

## Extract an adapter object

### Example

app/controllers/friends_controller.rb <!-- .element: class="filename" -->

```ruby
class FriendsController < ApplicationController
  def index
    friend_facebook_ids = Koala::Facebook::API.new(request.headers['X-Facebook-Token']).get_connections('me', 'friends').map { |friend| friend['id'] }

    render json: User.where(facebook_id: friend_facebook_ids)

  rescue Koala::Facebook::AuthenticationError => exc
    render json: { error: "Authentication Error: #{exc.message}" }, status: :unauthorized
  end
end
```

--

### Refactoring

app/adapters/facebook_adapter.rb <!-- .element: class="filename" -->

```ruby
class FacebookAdapter
  AuthenticationError = Class.new(StandardError)

  def initialize(token)
    @api = Koala::Facebook::API.new(token)
  end

  def friend_facebook_ids(token)
    @api.get_connections('me', 'friends').map { |friend| friend['id'] }
  rescue Koala::Facebook::AuthenticationError => exc
    raise AuthenticationError.new(exc.message)
  end
end
```

app/controllers/friends_controller.rb <!-- .element: class="filename" -->

```ruby
class FriendsController < ApplicationController
  def index
    render json: User.where(facebook_id: facebook_adapter.friend_facebook_ids)
  rescue FacebookAdapter::AuthenticationError => exc
    render json: { error: "Authentication Error: #{exc.message}" }, status: :unauthorized
  end

  private

  def facebook_adapter
    @facebook_adapter ||= FacebookAdapter.new(request.headers['X-Facebook-Token'])
  end
end
```

---

## Extract a delegator object

app/controllers/payment_gateway_controller.rb <!-- .element: class="filename" -->

```ruby
class PaymentGatewayController < ApplicationController
  ALLOWED_IPS = ["127.0.0.1"]
  before_action :whitelist_ip

  def callback
    order = Order.find(params[:order_id])
    transaction = order.order_transactions.create(callback: params.slice(:status, :error_message,
                                                                         :merchant_error_message, :shop_orderid,
                                                                         :transaction_id, :type, :payment_status,
                                                                         :masked_credit_card, :nature,
                                                                         :require_capture, :amount, :currency))

    if transaction.successful?
      order.paid!
      OrderMailer.order_paid(order.id).deliver
      redirect_to successful_order_path(order.id)
    else
      redirect_to retry_order_path(order.id)
    end

  rescue ActiveRecord::RecordNotFound => e
    redirect_to missing_order_path(params[:order_id])

  rescue => e
    Honeybadger.notify(e)
    AdminOrderMailer.order_problem(order.id).deliver
    redirect_to failed_order_path(order.id), alert: t("order.problems")
  end

  private

  def whitelist_ip
    raise UnauthorizedIpAccess unless ALLOWED_IPS.include?(request.remote_ip)
  end
end
```

--

### Refactoring

Move the action definition into new class and inherit from SimpleDelegator.

app/controllers/payment_gateway_controller.rb <!-- .element: class="filename" -->

```ruby
class PaymentGatewayController < ApplicationController
  ALLOWED_IPS = ["127.0.0.1"]
  before_action :whitelist_ip

  def callback
    PaymentGatewayCallback.new(self).callback
  end

  private

  def whitelist_ip
    raise UnauthorizedIpAccess unless ALLOWED_IPS.include?(request.remote_ip)
  end
end
```

--

app/delegators/payment_gateway_callback.rb <!-- .element: class="filename" -->

```ruby
class PaymentGatewayCallback < SimpleDelegator
  def callback
    order = Order.find(params[:order_id])
    transaction = order.order_transactions.create(callback: params.slice(:status, :error_message,
                                                                         :merchant_error_message, :shop_orderid,
                                                                         :transaction_id, :type, :payment_status,
                                                                         :masked_credit_card, :nature,
                                                                         :require_capture, :amount, :currency))

    if transaction.successful?
      order.paid!
      OrderMailer.order_paid(order.id).deliver
      redirect_to successful_order_path(order.id)
    else
      redirect_to retry_order_path(order.id)
    end

  rescue ActiveRecord::RecordNotFound => e
    redirect_to missing_order_path(params[:order_id])

  rescue => e
    Honeybadger.notify(e)
    AdminOrderMailer.order_problem(order.id).deliver
    redirect_to failed_order_path(order.id), alert: t("order.problems")
  end
end
```

--

### Refactoring

Controller responsibilities into the controller.

app/controllers/payment_gateway_controller.rb <!-- .element: class="filename" -->

```ruby
class PaymentGatewayController < ApplicationController
  ALLOWED_IPS = ["127.0.0.1"]
  before_action :whitelist_ip

  def callback
    if PaymentGatewayCallback.new.callback(
        params[:order_id],
        gateway_transaction_attributes
      )
      redirect_to successful_order_path(params[:order_id])
    else
      redirect_to retry_order_path(params[:order_id])
    end

  rescue ActiveRecord::RecordNotFound => e
    redirect_to missing_order_path(params[:order_id])

  rescue
    redirect_to failed_order_path(params[:order_id]), alert: t("order.problems")
  end

  private

  def whitelist_ip
    raise UnauthorizedIpAccess unless ALLOWED_IPS.include?(request.remote_ip)
  end

  def gateway_transaction_attributes
    params.slice(:status, :error_message, :merchant_error_message,
      :shop_orderid, :transaction_id, :type, :payment_status,
      :masked_credit_card, :nature, :require_capture, :amount, :currency
    )
  end
end
```

--

app/delegators/payment_gateway_callback.rb <!-- .element: class="filename" -->

```ruby
class PaymentGatewayCallback
  def callback(order_id, gateway_transaction_attributes)
    order = Order.find(order_id)
    transaction = order.order_transactions.create(callback: gateway_transaction_attributes)

    if transaction.successful?
      order.paid!
      OrderMailer.order_paid(order.id).deliver
      return true
    else
      return false
    end

  rescue ActiveRecord::RecordNotFound => e
    raise

  rescue => e
    Honeybadger.notify(e)
    AdminOrderMailer.order_problem(order.id).deliver
    raise
  end
end
```

---

## Extract a form object

app/controllers/users_controller.rb <!-- .element: class="filename" -->

```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(signup_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Signup successful.' }
      else
        format.html { render new_signup_path }
      end
    end
  end

  private

  def signup_params
    params.require(:user).permit(:name, :email, :password)
  end
end
```

--

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ActiveRecord::Base
  attr_accessor :password
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: { on: :create}, length: { within: 8..255, allow_blank: true }
end
```

--

### Refactoring

app/controllers/users_controller.rb <!-- .element: class="filename" -->

```ruby
class UsersController < ApplicationController
  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)

    respond_to do |format|
      if @signup.save
        format.html { redirect_to @signup.user, notice: 'Signup successful.' }
      else
        format.html { render new_signup_path }
      end
    end
  end

  private

  def signup_params
    params.require(:user).permit(:name, :email, :password)
  end
end
```

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ActiveRecord::Base
  attr_accessor :password
end
```

--

app/forms/Signup.rb <!-- .element: class="filename" -->

```ruby
class Signup
  include ActiveModel::Model
  include Virtus.model

  attr_reader :user

  attribute :name, String
  attribute :email, String
  attribute :password, String

  validates :name, presence: true
  validates :email, presence: true
  validates :password, length: { within: 8..255 }

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    @user = User.new(name: name, email: email, password: password).save!(validate: false)
  end
end
```

---

## Extract a query object

### Example

app/controllers/tickets_controller.rb <!-- .element: class="filename" -->

```ruby
class TicketsController < ApplicationController
  def index
    @tickets = current_user.tickets
    if @params['from'].present?
      @tickets = @tickets.where('DATE(created_at) >= ?', Date.parse(@params['from']))
    end
    if @params['to'].present?
      @tickets = @tickets.where('DATE(created_at) <= ?', Date.parse(@params['to']))
    end
    if @params['state'].present?
      @tickets = @tickets.where('state = ?', Ticket.states[@params['state']])
    end
    if @params['status_id'].present?
      @tickets = @tickets.where(ticket_status_id: @params['status_id'])
    end
  end
end
```

--

### Refactoring

app/controllers/tickets_controller.rb <!-- .element: class="filename" -->

```ruby
class TicketsController < ApplicationController
  def index
    @tickets = TicketSearch.new(current_user, params).call
  end
end
```

--

app/queries/ticket_search.rb <!-- .element: class="filename" -->

```ruby
class TicketSearchService
  def initialize(user, params)
    @params, @tickets = params, user.tickets
  end

  def call
    by_date
    by_state
    by_status
    @tickets
  end

  private

  def by_date
    if @params['from'].present?
      @tickets = @tickets.where('DATE(created_at) >= ?', Date.parse(@params['from']))
    end
    if @params['to'].present?
      @tickets = @tickets.where('DATE(created_at) <= ?', Date.parse(@params['to']))
    end
  end

  def by_state
    if @params['state'].present?
      @tickets = @tickets.where('state = ?', Ticket.states[@params['state']])
    end
  end

  def by_status
    if @params['status_id'].present?
      @tickets = @tickets.where(ticket_status_id: @params['status_id'])
    end
  end
end
```

---

## Callbacks

Callbacks are a convenient way to decorate the default save method with custom persistence logic. Callbacks are frequently abused by adding non-persistence logic, such as sending emails or processing payments.

### Symptoms
* Callbacks which contain business logic such as processing payments.
* Attributes which allow certain callbacks to be skipped.
* Methods such as save_without_sending_email which skip callbacks.
* Callbacks which need to be invoked conditionally.
--

### Example

app/models/event.rb <!-- .element: class="filename" -->

```ruby
def deliver_invitations
  recipients.map do |recipient_email|
    Invitation.create!(
      event: event,
      sender: sender,
      recipient_email: recipient_email,
      status: 'pending',
      message: @message
    )
  end
end
```
app/models/invitation.rb <!-- .element: class="filename" -->

```ruby
after_create :deliver

private

def deliver
  Mailer.invitation_notification(self).deliver
end
```

--

### Refactoring

app/models/invitation.rb <!-- .element: class="filename" -->

```ruby
def deliver
  Mailer.invitation_notification(self).deliver
end

private
```

app/models/event.rb <!-- .element: class="filename" -->

```ruby
def deliver_invitations
  create_invitations.each(&:deliver)
end

def create_invitations
  Invitation.transaction do
    recipients.map do |recipient_email|
      Invitation.create!(
        event: event,
        sender: sender,
        recipient_email: recipient_email,
        status: 'pending',
        message: @message
      )
    end
  end
end
```
---

## Convention Over Configuration

Ruby’s metaprogramming allows us to avoid boilerplate code and duplication by relying on conventions for class names, file names, and directory structure. Careful use of conventions will make your applications less tedious and more bug-proof.

### Uses
* Eliminate Case Statements by finding classes by name.
* Prevents future duplication, making it easier to avoid duplication.
* Eliminate Shotgun Surgery by removing the need to register or configure new strategies and services.
* Remove Duplicated Code by removing manual associations from identifiers to class names.
--

### Example

This controller accepts an id parameter identifying which summarizer strategy to use and renders a summary of the survey based on the chosen strategy:

app/controllers/summaries_controller.rb <!-- .element: class="filename" -->

```ruby
class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summarize(summarizer)
  end

  private

  def summarizer
    case params[:id]
    when 'breakdown'
      Breakdown.new
    when 'most_recent'
      MostRecent.new
    when 'your_answers'
      UserAnswer.new(current_user)
    else
      raise "Unknown summary type: #{params[:id]}"
    end
  end
end
```

--

### Refactoring

We will use **constantize** method. But there are some outlier cases:

1. The UserAnswer class is referenced using "your_answers" instead of "user_answer".

2. UserAnswer takes different parameters than the other two strategies.

So, let's refactor to obey convention:

app/controllers/summaries_controller.rb <!-- .element: class="filename" -->

```ruby
def summarizer
  case params[:id] # Each class accept the same parameters
  when 'breakdown'
    Breakdown.new(user: current_user)
  when 'most_recent'
    MostRecent.new(user: current_user)
  when 'user_answer' # The reference corresponds to the convention
    UserAnswer.new(user: current_user)
  else
    raise "Unknown summary type: #{params[:id]}"
  end
end
```

--

app/controllers/summaries_controller.rb <!-- .element: class="filename" -->

```ruby
def summarizer
  summarizer_class.new(user: current_user)
end

def summarizer_class
  params[:id].classify.constantize
end
```
Now we’ll never need to change our controller when adding a new strategy;
we just add a new class following the naming convention.


--

### Scoping **constantize**

Our controller currently takes a string directly from user input (params) and instantiates a class with that name.

1. Without a whitelist, a user can make the application instantiate any class.

2. There’s no list of available strategies.

app/controllers/summaries_controller.rb <!-- .element: class="filename" -->

```ruby
def summarizer_class
  "Summarizer::#{params[:id].classify}".constantize
end
```
With this convention in place, you can find all strategies by just looking in the **Summarizer** module. In a Rails application, this will be in a summarizer directory by convention.

--

### Drawbacks

1. Conventions are most valuable when they’re completely consistent. In our case convention is slightly forced in this case because UserAnswer needs different parameters than the other two strategies.

2. This class-based approach, while convenient when developing an application, is more likely to cause frustration when writing a library. Forcing developers to pass a class name instead of an object.

---

## Validator

Extract validator used to remove complex validation details from ActiveRecord models. This technique also prevents duplication of validation code across several files.

### Uses
* Keep validation implementation details out of models.
* Encapsulate validation details into a single file, following the Single Responsibility Principle.
* Make validation logic easier to reuse, making it easier to avoid duplication.
--

### Example

app/models/invitation.rb <!-- .element: class="filename" -->

```ruby
class Invitation < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :recipient_email, presence: true, format: EMAIL_REGEX
end
```
We extract the validation details into a new class EmailValidator, and place the new class into the app/validators directory.

app/validators/email_validator.rb <!-- .element: class="filename" -->

```ruby
class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  def validate_each(record, attribute, value)
    unless value.match EMAIL_REGEX
      record.errors.add(attribute, "#{value} is not a valid email")
    end
  end
end
```

Once the validator has been extracted. Rails has a convention for using the new validation class. EmailValidator is used by setting email: true in the validation arguments.

```ruby
class Invitation < ActiveRecord::Base
  validates :recipient_email, presence: true, email: true
end
```

---

## Value Object

Value Objects are objects that represent a value (such as a dollar amount) rather than a unique, identifiable entity (such as a particular user).

### Uses
* Remove Duplicated Code from making the same observations of primitive objects throughout the code base.
* Make the code easier to understand by fully-encapsulating related logic into a single class, following the Single Responsibility Principle.
* Eliminate Divergent Change by extracting code related to an embedded semantic type.
--

### Example

app/controllers/invitations_controller.rb <!-- .element: class="filename" -->

```ruby
def recipient_list
  @recipient_list ||= recipients.gsub(/\s+/, '').split(/[\n,;]+/)
end

def recipients
  params[:invitation][:recipients]
end
```

We can extract a new class to offload this responsibility.

--

app/models/recipient_list.rb <!-- .element: class="filename" -->

```ruby
class RecipientList
  include Enumerable

  def initialize(recipient_string)
    @recipient_string = recipient_string
  end

  def each(&block)
    recipients.each(&block)
  end

  def to_s
    @recipient_string
  end

  private

  def recipients
    @recipient_string.to_s.gsub(/\s+/, '').split(/[\n,;]+/)
  end
end
```

app/controllers/invitations_controller.rb <!-- .element: class="filename" -->


```ruby
def recipient_list
  @recipient_list ||= RecipientList.new(params[:invitation][:recipients])
end
```

---

## Trailblazer

https://github.com/trailblazer/trailblazer

## Rectify

https://github.com/andypike/rectify

## MVC refactoring in Rails

https://www.sitepoint.com/the-basics-of-mvc-in-rails-skinny-everything/

https://www.sitepoint.com/7-design-patterns-to-refactor-mvc-components-in-rails/

https://github.com/rubygarage/mvc-components-refactoring-in-rails

---

# The End
