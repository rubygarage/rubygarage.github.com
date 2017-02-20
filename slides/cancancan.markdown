---
layout: slide
title:  CanCanCan
---

# CanCanCan

<br>

[Go to Table of Contents](/)

---

# CanCanCan

It is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. All permissions are defined in a single location (the Ability class) and not duplicated across controllers, views, and database queries

---

## Install CanCan

Gemfile <!-- .element: class="filename" -->

```ruby
gem 'cancancan'
```

```bash
$ bundle
$ rails g cancan:ability
  create  app/models/ability.rb
```
---

## Ability

app/models/ability.rb <!-- .element: class="filename" -->

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
```

---

## Defining Abilities

app/models/ability.rb <!-- .element: class="filename" -->

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Post, active: true
    can [:read, :create, :update, :destroy], Post, user_id: user.id
  end
end
```

---

## Checking Abilities in Views

app/views/posts/index.html.erb <!-- .element: class="filename" -->

```html
<ul>
  <% @posts.each do |post| %>
    <li>
      <%= post.title %>
      <%- if can? :read, post %>
        <%= link_to 'Show', post %>
      <%- end %>
      <%- if can? :update, post %>
        <%= link_to 'Edit', edit_post_path(post) %>
      <%- end %>
      <%- if can? :destroy, post %>
        <%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %>
      <%- end %>
    </li>
  <% end %>
</ul>
```

---

## Checking Abilities in Controllers

You can use the `authorize!` method to manually handle authorization in a controller action. This will raise a `CanCan::AccessDenied` exception when the user does not have permission.

Sometimes you need to restrict which records are returned from the database based on what the user is able to access. This can be done with the `accessible_by` method on any Active Record model. Simply pass it the current ability to find only the records which the user is able to `:read`.

--

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.accessible_by(current_ability)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize! :show, @post
  end

  # GET /posts/new
  def new
    @post = Post.new(user_id: current_user.id)
    authorize! :create, @post
  end

  # GET /posts/1/edit
  def edit
    authorize! :update, @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    authorize! :create, @post

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize! :update, @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize! :destroy, @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :text)
    end
end
```

---

## Authorizing Controller actions

app/controllers/posts_controller.rb <!-- .element: class="filename" -->

```ruby
class PostsController < ApplicationController
  load_and_authorize_resource except: [:create]

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
```

---

## Testing Abilities

spec/models/ability_spec.rb <!-- .element: class="filename" -->

```ruby
require 'cancan/matchers'

describe Ability do
  describe "abilities of loggined user" do
    subject { ability }

    let(:ability){ Ability.new(user) }
    let(:user){ FactoryGirl.create(:user) }
    let(:post){ FactoryGirl.create(:post, user: user) }
    let(:other_post){ FactoryGirl.create(:post) }

    context 'for posts' do
      it { expect(ability).to be_able_to(:read, post) }
      it { expect(ability).to be_able_to(:create, Post) }
      it { expect(ability).to be_able_to(:update, post) }
      it { expect(ability).to be_able_to(:destroy, post) }

      it { expect(ability).not_to be_able_to(:read, other_post) }
      it { expect(ability).not_to be_able_to(:update, other_post) }
      it { expect(ability).not_to be_able_to(:destroy, other_post) }
    end
  end
end
```

---

## Testing Controllers

spec/controllers/posts_controller_spec.rb <!-- .element: class="filename" -->

```ruby
describe PostsController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @post = FactoryGirl.create(:post, user: @user)

    Post.stub(:find).and_return(@post)
    @post_attributes = FactoryGirl.attributes_for(:post)

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
    @ability.can :manage, :all

    sign_in(@user)
  end

  context '#new' do
    context 'cancan doesnt allow :new' do
      before do
        @ability.cannot :create, Post
        get :new
      end
      it{ should redirect_to root_path}
    end
  end

  context '#show' do
    context 'cancan doesnt allow :show' do
      before do
        @ability.cannot :show, Post
        get :show, {id: @post.id}
      end
      it{ should redirect_to root_path}
    end
  end

  context '#create' do
    context 'cancan doesnt allow :create' do
      before do
        @ability.cannot :create, Post
        post :create, {post: @post_attributes}
      end
      it{ should redirect_to root_path}
    end
  end

  context '#update' do
    context 'cancan doesnt allow :update' do
      before do
        @ability.cannot :update, @post
        put :update, @post_attributes.merge(id: @post.id)
      end
      it{ should redirect_to root_path}
    end
  end

  context '#destroy' do
    context 'cancan doesnt allow :destroy' do
      before do
        @ability.cannot :destroy, @post
        delete :destroy, id: @post.id
      end
      it{ should redirect_to root_path}
    end
  end
end
```

---

## CanCanCan Docs

[Defining Abilities](https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities)

[Checking Abilities](https://github.com/CanCanCommunity/cancancan/wiki/checking-abilities)

[Authorizing controller actions](https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions)

and

[CanCanCan Wiki](https://github.com/CanCanCommunity/cancancan/wiki)

---

# The End

<br>

[Go to Table of Contents](/)
