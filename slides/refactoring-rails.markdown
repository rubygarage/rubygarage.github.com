---
layout: slide
title:  Refactoring Controllers
---

# Refactoring. Controllers.
When you work on a big project, you’re pushed to deliver new features. The business rarely understands the reasons for
refactoring.
Refactoring is an ongoing activity. Refactoring is a team activity. Refactoring is best when everyone understands the
reasons and agrees on the direction of the code changes.

---

## Inline controller filters
Using controller filters is a very popular approach in Rails apps. This technique is used for implementing
cross-cutting concerns, like authorization, auditing and data loading.
Often, the filters introduce coupling between the controller action and the result of the filters. Sometimes the
coupling doesn’t hurt much. Sometimes, though, the filters prepare some global state using the instance variables. That
makes the coupling worse, as it’s difficult to extract a service object from a controller.
### Example
```ruby
class TimelogController  [:create]
def create
@time_entry ||= TimeEntry.new(:project => @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
@time_entry.safe_attributes = params[:time_entry]
call_hook(:controller_timelog_edit_before_save, { :params => params, :time_entry => @time_entry })
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
### Refactoring
```ruby
class TimelogController  @project, :issue => @issue, :user => User.current, :spent_on => User.current.today)
@time_entry.safe_attributes = params[:time_entry]
call_hook(:controller_timelog_edit_before_save, { :params => params, :time_entry => @time_entry })
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
config/routes.rb
```ruby
resources :users do
member do
get :following, :followers
end
end
```
app/controllers/users_controller.rb
```ruby
class UsersController
### Refactoring
config/routes.rb
```ruby
resources :users do
member do
get :followers, controller: 'followers'
get :following, controller: 'following'
end
end
```
app/controllers/followers_controller.rb
```ruby
class FollowersController
app/controllers/following_controller.rb
```ruby
class FollowingController

---

## Controller concerns
### Example
app/controllers/followers_controller.rb
```ruby
class FollowersController
app/controllers/following_controller.rb
```ruby
class FollowingController
### Refactoring
app/controllers/concerns/signed_in_user.rb
```ruby
module SignedInUser
extend ActiveSupport::Concern
included do
before_action :signed_in_user
end
end
```
app/controllers/followers_controller.rb
```ruby
class FollowersController
app/controllers/following_controller.rb
```ruby
class FollowingController

---

## Service objects
Services are not the silver bullet. They don’t solve all the problems. They are good as the first step into the process
of improving the design of your application.
### Bryan Helmkamp
Some actions in a system warrant a Service Object to encapsulate their operation. I reach for Service Objects when an
action meets one or more of these criteria:
* The action is complex (e.g. closing the books at the end of an accounting period)
* The action reaches across multiple models (e.g. an e-commerce purchase using Order, CreditCard and Customer objects)
* The action interacts with an external service (e.g. posting to social networks)
* The action is not a core concern of the underlying model (e.g. sweeping up outdated data after a certain time period)
* There are multiple ways of performing the action (e.g. authenticating with an access token or password). This is the
Gang of Four Strategy pattern
### Eric Evans
`Service:` A standalone operation within the context of your domain. A Service Object collects one or more services
into an object. Typically you will have only one instance of each service object type within your execution context.
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
app/controllers/friends_controller.rb
```ruby
class FriendsController  exc
render json: { error: "Authentication Error: #{exc.message}" }, status: :unauthorized
end
end
```
### Refactoring
app/adapters/facebook_adapter.rb
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
app/controllers/friends_controller.rb
```ruby
class FriendsController  exc
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
### Example
app/controllers/payment_gateway_controller.rb
```ruby
class PaymentGatewayController  e
redirect_to missing_order_path(params[:order_id])
rescue => e
Honeybadger.notify(e) AdminOrderMailer.order_problem(order.id).deliver
redirect_to failed_order_path(order.id), alert: t("order.problems")
end
private
def whitelist_ip
raise UnauthorizedIpAccess unless ALLOWED_IPS.include?(request.remote_ip)
end
end
```
### Refactoring. Move the action definition into new class and inherit from SimpleDelegator.
app/controllers/payment_gateway_controller.rb
```ruby
class PaymentGatewayController
app/delegators/payment_gateway_callback.rb
```ruby
class PaymentGatewayCallback  e
redirect_to missing_order_path(params[:order_id])
rescue => e
Honeybadger.notify(e)
AdminOrderMailer.order_problem(order.id).deliver
redirect_to failed_order_path(order.id), alert: t("order.problems")
end
end
```
### Refactoring. Controller responsibilities into the controller.
app/controllers/payment_gateway_controller.rb
```ruby
class PaymentGatewayController  e
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
app/delegators/payment_gateway_callback.rb
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
Honeybadger.notify(e) AdminOrderMailer.order_problem(order.id).deliver
raise
end
end
```

---

## Extract a form object
### Example
app/controllers/users_controller.rb
```ruby
class UsersController
app/models/user.rb
```ruby
class User
### Refactoring
app/controllers/users_controller.rb
```ruby
class UsersController
app/models/user.rb
```ruby
class User
app/forms/Signup.rb
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
```ruby
class TicketsController = ?', Date.parse(@params['from']))
end
if @params['to'].present?
@tickets = @tickets.where('DATE(created_at)
### Refactoring
app/controllers/tickets_controller.rb
```ruby
class TicketsController
app/queries/ticket_search.rb
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
@tickets = @tickets.where('DATE(created_at)
