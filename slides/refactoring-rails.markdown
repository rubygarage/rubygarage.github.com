---
layout: slide
title:  Refactoring Controllers
---

# Refactoring. Controllers.

> When you work on a big project, you’re pushed to deliver new features. The business rarely understands the reasons for
refactoring.

> Refactoring is an ongoing activity. Refactoring is a team activity. Refactoring is best when everyone understands the
reasons and agrees on the direction of the code changes.

<br>

[Go to Table of Contents](/)

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
        format.html { redirect_to @user, notice: 'Signup successfull.' }
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
        format.html { redirect_to @signup.user, notice: 'Signup successfull.' }
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

<br>

[Go to Table of Contents](/)
