---
layout: slide
title:  Models
---

# Models

<br>

[Go to Table of Contents](/)

---

# Active Record Models

`Active Record` is the `M` in
[MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) - the model - which is the
layer of the system responsible for representing business data and logic. It is an implementation of
[the Active Record pattern](http://en.wikipedia.org/wiki/Active_record_pattern) which itself is a
description of an [Object Relational
Mapping](https://en.wikipedia.org/wiki/Object-relational_mapping) (ORM) system.

Active Record gives us several mechanisms, the most important being the ability to:

- Represent models and their data
- Represent associations between these models
- Represent inheritance hierarchies through related models
- Validate models before they get persisted to the database
- Perform database operations in an object-oriented fashion

---

# Models generation

```bash
$ rails generate model User first_name:string email:string password:string
invoke  active_record
create    db/migrate/20160410131731_create_users.rb
create    app/models/user.rb
invoke    test_unit
create      test/models/user_test.rb
create      test/fixtures/users.yml
```

---

# Naming Conventions

- Database Table - Plural with underscores separating words (e.g., book_clubs)
- Model Class - Singular with the first letter of each word capitalized (e.g., BookClub)

| Model / Class | Table / Schema |
| ---           | ---            |
| Post          | posts          |
| LineItem      | line_items     |
| Deer          | deer           |
| Mouse         | mice           |
| Person        | people         |

---

# Active Record Migrations

`Migrations` are a feature of Active Record that allows you to evolve your database schema over time. Rather than
write schema modifications in pure SQL, migrations allow you to use an easy Ruby DSL to describe changes to your
tables.

---

# Overview

```ruby
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
```

---

# Schema Conventions

- `Foreign keys` - These fields should be named following the pattern singularized_table_name_id
  (e.g., item_id, order_id). These are the fields that Active Record will look for when you create
  associations between your models.

- `Primary keys` - By default, Active Record will use an integer column named id as the table's
  primary key. When using Rails Migrations to create your tables, this column will be automatically
  created.

- `created_at` - Automatically gets set to the current date and time when the record is first created.

- `updated_at` - Automatically gets set to the current date and time whenever the record is updated.

- `lock_version` - Adds optimistic locking to a model.

- `type` - Specifies that the model uses Single Table Inheritance.

- `(association_name)_type` - Stores the type for polymorphic associations.

- `(table_name)_count` - Used to cache the number of belonging objects on associations. For example,
  a comments_count column in a Post class that has many instances of Comment will cache the number
  of existent comments for each post.

---

# Add Migrations

```bash
$ rails g migration AddLastNameToUsers last_name:string:index
invoke  active_record
create    db/migrate/20160410133524_add_last_name_to_users.rb
```

```bash
# YYYYMMDDHHMMSS UTC timestamp
20160410133524_add_last_name_to_users.rb
```

--

## Change

db/migrate/20160410133524_add_last_name_to_users.rb <!-- .element: class="filename" -->

```ruby
class AddLastNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_name, :string
    add_index :users, :last_name
  end
end
```

```bash
$ rails g migration AddReceiveNewsToUsers receive_news:boolean
invoke  active_record
create    db/migrate/20160410133746_add_receive_news_to_users.rb
```

db/migrate/20160410133746_add_receive_news_to_users.rb <!-- .element: class="filename" -->

```ruby
class AddReceiveNewsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_news, :boolean
  end
end
```

--

## Up and down (old style)

db/migrate/20160410133746_add_receive_news_to_users.rb <!-- .element: class="filename" -->

```ruby
class AddReceiveNewsToUsers < ActiveRecord::Migration[5.0]
  def up
    change_table :users do |t|
      t.boolean :receive_news, default: true
      t.index :receive_news
    end

    User.update_all ["receive_news = ?", true]
  end

  def down
    remove_column :users, :receive_news
  end
end
```

--

## Reversible

db/migrate/20160410133746_change_user_number.rb <!-- .element: class="filename" -->

```ruby
class ChangeUsersNumber < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      change_table :users do |t|
        dir.up   { t.change :user_number, :string }
        dir.down { t.change :user_number, :integer }
      end
    end
  end
end

class ChangeUsersNumber < ActiveRecord::Migration[5.0]
  def up
    change_table :users do |t|
      t.change :user_number, :string
    end
  end

  def down
    change_table :users do |t|
      t.change :user_number, :integer
    end
  end
end
```

If your migration is irreversible, you should raise `ActiveRecord::IrreversibleMigration` from your
down method. If someone tries to revert your migration, an error message will be displayed saying
that it can't be done.

---

## Reverse previous migration

```ruby
require_relative '20160410133746_change_user_number'

class FixupChangeUserNumberMigration < ActiveRecord::Migration[5.0]
  def change
   revert ChangeUsersNumber

   create_table(:users) do |t|
     t.string :variety
   end
  end
end
```

```ruby
class FixupChangeUserNumberMigration < ActiveRecord::Migration[5.0]
   def change
     revert do
       # copy-pasted code from ChangeUsersNumber
       reversible do |dir|
         change_table :users do |t|
           dir.up   { t.change :user_number, :string }
           dir.down { t.change :user_number, :integer }
         end
       end

       # The rest of the migration was ok
     end
   end
end
```

---

## Methods for db structure changing

`create_table`

```ruby
create_table :friends do |t|
  t.string :first_name
  t.string :last_name
  t.string :email
  t.timestamps
end
```

`change_table`

```ruby
change_table :friends do |t|
  t.remove :last_name, :first_name
  t.string :phone_number
  t.index  :phone_number
end
```

--

`add_column`

```ruby
add_column :friends, :first_name, :string
add_column :friends, :last_name, :integer
```

`add_foreign_key`

```ruby
#If the column names can not be derived from the table names, use the :column and :primary_key options.
add_foreign_key :friends, :users
```

`change_column`

```ruby
change_column :friends, :last_name, :string
```

`change_column_null`

```ruby
change_column_null :users, :receive_news, false
```

`change_column_default`

```ruby
change_column_default :users, :receive_news, from: true, to: false
```

--

`create_join_table`

```ruby
create_join_table :users, :friends do |t|
  # t.index [:user_id, :friend_id]
  # t.index [:friend_id, :user_id]
end
```

`drop_join_table`

```ruby
drop_join_table :users, :friends
```

`rename_column`

```ruby
rename_column :friends, :last_name, :surname
```

`remove_column`

```ruby
remove_column :friends, :surname
```

--

`add_index`

```ruby
add_index :friends, :email
```

`add_reference`

```ruby
add_reference :friends, :user, index: true, foreign_key: true
```

`add_timestamps`

```ruby
add_timestamps :users
```

`remove_index`

```ruby
remove_index :friends, :email
```

`drop_table`

```ruby
drop_table :friends
```

--

`enable_extension`

```ruby
enable_extension 'hstore'
```

`disable_extension`

```ruby
disable_extension 'hstore'
```

`remove_foreign_key`

```ruby
remove_foreign_key :users, :friends
remove_foreign_key :users, column: :my_friend_id
remove_foreign_key :users, name: :special_fk_name
```

`remove_reference`

```ruby
remove_reference :users, :client
```

`remove_timestamps`

```ruby
remove_timestamps :users
```

--

`rename_index`

```ruby
rename_index :users, :index_first_name, :index_first_user_name
```

`rename_table`

```ruby
rename_table :users, :customers
```

---

# Column Types

- `:binary`
- `:boolean`
- `:date`
- `:datetime`
- `:decimal`
- `:float`
- `:integer`
- `:primary_key`
- `:string`
- `:text`
- `:time`
- `:timestamp`
- `:references`

---

## Example Migration

```ruby
class ExampleMigration < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.references :group
    end
    #add a foreign key
    execute <<-SQL
      ALTER TABLE products
        ADD CONSTRAINT fk_users_groups
        FOREIGN KEY (group_id)
        REFERENCES groups(id)
    SQL
    add_column :users, :home_page_url, :string
    rename_column :users, :email, :email_address
  end

  def down
    rename_column :users, :email_address, :email
    remove_column :users, :home_page_url
    execute <<-SQL
      ALTER TABLE users
        DROP FOREIGN KEY fk_users_groups
    SQL
    drop_table :users
  end
end
```

--

```ruby
class ExampleMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :distributors do |t|
      t.string :zipcode
    end

    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE distributors
            ADD CONSTRAINT zipchk
              CHECK (char_length(zipcode) = 5) NO INHERIT;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE distributors
            DROP CONSTRAINT zipchk
        SQL
      end
    end

    add_column :users, :home_page_url, :string
    rename_column :users, :email, :email_address
  end
end
```

--

```ruby
require_relative '20121212123456_example_migration'

class FixupExampleMigration < ActiveRecord::Migration[5.0]
  def change
    revert ExampleMigration

    create_table(:apples) do |t|
      t.string :variety
    end
  end
end
```

--

```ruby
class DontUseConstraintForZipcodeValidationMigration < ActiveRecord::Migration[5.0]
  def change
    revert do
      # copy-pasted code from ExampleMigration
      reversible do |dir|
        dir.up do
          # add a CHECK constraint
          execute <<-SQL
            ALTER TABLE distributors
              ADD CONSTRAINT zipchk
                CHECK (char_length(zipcode) = 5);
          SQL
        end
        dir.down do
          execute <<-SQL
            ALTER TABLE distributors
              DROP CONSTRAINT zipchk
          SQL
        end
      end

      # The rest of the migration was ok
    end
  end
end
```

---

## Run run run ruuuuuuuuun

Running Migrations

```bash
$ rails db:migrate
```

Rollback Migrations

```bash
$ rails db:rollback
$ rails db:rollback STEP=3
$ rails db:migrate:down VERSION=20160410211749
$ rails db:migrate:up VERSION=20160410211749
$ rails db:migrate:redo STEP=3
```

---

# Active Record Objects

--

## ActiveRecord functions

```bash
$ rails c
```

## new

```ruby
user = User.new
# => #<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false >]
```

## save

```ruby
user.first_name = 'Anna'
# => "Anna"

user.email = 'happy_ann@gmail.com'
# => "happy_ann@gmail.com"

user.save
# INSERT INTO "users" ("created_at", "email", "first_name", "last_name", "password", "receive_news", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 19:00:01 UTC +00:00], ["email", "happy_ann@gmail.com"], ["first_name", "Anna"], ["last_name", nil], ["password", nil], ["receive_news", false], ["updated_at", Sun, 10 Apr 2016 19:00:01 UTC +00:00]]
# => true
```

--

## all

```ruby
User.all
# SELECT "users".* FROM "users"
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2016-04-10 19:00:01", updated_at: "2016-04-10 19:00:01", receive_news: nil, last_name: nil>]>
```

### Rails 3

```ruby
User.all.class
# SELECT "users".* FROM "users"
# => Array
```

### Rails 4

```ruby
User.all.class
# => ActiveRecord::Relation
```

--

## create

```bash
new_user = User.create(first_name: 'Ivan', email: 'ivan.melechov@gmail.com')
# (0.1ms)  begin transaction
# SQL (1.5ms)  INSERT INTO "users" ("first_name", "email", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["first_name", "Ivan"], ["email", "ivan.melechov@gmail.com"], ["created_at", 2016-04-10 19:09:42 UTC], ["updated_at", 2016-04-10 19:09:42 UTC]]
# (0.8ms)  commit transaction
# => #<User id: 2, first_name: "Ivan", email: "ivan.melechov@gmail.com", password: nil, created_at: "2016-04-10 19:09:42", updated_at: "2016-04-10 19:09:42", receive_news: nil, last_name: nil>
```

## count

```bash
User.count
# SELECT COUNT(*) FROM "users"
# => 2
```

## update

```bash
new_user.update(first_name: "Van'ka", email: "vanka@yandex.ru")
# (0.1ms)  begin transaction
# SQL (0.4ms)  UPDATE "users" SET "first_name" = ?, "email" = ?, "updated_at" = ? WHERE "users"."id" = ?  [["first_name", "Van'ka"], ["email", "vanka@yandex.ru"], ["updated_at", 2016-04-10 19:11:53 UTC], ["id", 2]]
# (0.7ms)  commit transaction
# => true
```

---

# Active Record Associations

---

## belongs_to

![](/assets/images/belongs_to.svg)

```ruby
class Post < ActiveRecord::Base
  belongs_to :user
end
```

--

```bash
$ rails g migration AddUserRefToPosts user:references
invoke  active_record
create    db/migrate/20160410164224_add_user_ref_to_posts.rb
```

db/migrate/20160410164224_add_user_ref_to_posts.rb <!-- .element: class="filename" -->

```ruby
class AddUserRefToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :user, index: true
  end
end
```

```bash
$ rake db:migrate
==  AddUserRefToPosts: migrating ==============================================
-- add_reference(:posts, :user, {:index=>true})
==  AddUserRefToPosts: migrated (0.0054s) =====================================
```

--

app/models/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ApplicationRecord
  belongs_to :user
end
```

```bash
user = User.first
# SELECT "users".* FROM "users" LIMIT 1
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2016-04-10 16:53:04", updated_at: "2016-04-10 16:53:04", last_name: nil, receive_news: false>
```

```bash
post = Post.create(text: "I'm so happy today", title: "So happy", user_id: user.id)
# INSERT INTO "posts" ("created_at", "text", "title", "updated_at", "user_id") VALUES (?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 16:55:11 UTC +00:00], ["text", "I'm so happy today"], "So happy", ["updated_at",Sun, 10 Apr 2016 16:55:11 UTC +00:00], ["user_id", 1]]
# (126.0ms)  commit transaction
# => #<Post id: 1, text: "I'm so happy today", title: "So happy", user_id: 1, created_at: "2016-04-10 16:55:11", updated_at: "2016-06-02 16:55:11">
```

```bash
post.user
# SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2016-04-10 16:55:11", updated_at: "2016-04-10 16:55:11", last_name: nil, receive_news: false>
```

From Rails 5 on every Rails application will have a new configuration option

`config.active_record.belongs_to_required_by_default = true` , it will trigger a validation error
when trying to save a model where belongs_to associations are not present.

or

```ruby
belongs_to :user, optional: true
```

---

## has_many

![](/assets/images/has_many.svg)

```ruby
class User < ActiveRecord::Base
  has_many :posts
end
```

--

## has_many

app/models/user.rb <!-- .element: class="filename" -->
```ruby
class User < ActiveRecord::Base
  has_many :posts
end
```

### Get posts

```ruby
user.posts
# SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = 1
# => [#<Post id: 1, text: "I'm so happy today", title: "So happy", user_id: 1, created_at: "2016-04-10 16:55:11", updated_at: "2016-04-10 16:55:11">]
```

### Count Posts

```ruby
user.posts.count
# SELECT COUNT(*) FROM "posts" WHERE "posts"."user_id" = 1
# => 2
```

--

### Create Post

```ruby
user.posts << Post.new(text: "I'm waiting")
# INSERT INTO "posts" ("created_at", "text",  "updated_at", "user_id") VALUES (?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 19:20:23 UTC +00:00], ["text", "I'm waiting"], ["updated_at", Sun, 10 Apr 2016 19:20:23 UTC +00:00], ["user_id", 1]]
# => [#<Post id: 1, text: "I'm so happy today", title: "So happy", user_id: 1, created_at: "2016-04-10 16:55:11", updated_at: "2016-04-10 16:55:11">, #<Post id: 2, text: "I'm waiting", title: nil, user_id: 1, created_at: "2016-04-10 19:20:23", updated_at: "2016-04-10 19:20:23">]
```

or

```ruby
user.posts.create(text: "New post")
# INSERT INTO "posts" ("created_at", "text","updated_at", "user_id") VALUES (?, ?, ?, ?)  [["created_at", Sun, 10 Jun 2016 19:25:27 UTC +00:00], ["text", "New post"], ["updated_at", Sun, 10 Jun 2016 19:25:27 UTC +00:00], ["user_id", 1]]
# => #<Post id: 3, text: "New post", title: nil, user_id: 1, created_at: "2016-04-10 19:25:27", updated_at: "2016-04-10 19:25:27">
```

---

## has_one

![](/assets/images/has_one.svg)

```ruby
class Post < ActiveRecord::Base
  has_one :post_info
end
```

--

```bash
$ rails g model PostInfo post_id:integer views:integer likes:integer rating:integer
```

app/models/post_info.rb <!-- .element: class="filename" -->

```ruby
class PostInfo < ApplicationRecord
  belongs_to :post
end
```

app/models/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ApplicationRecord
  belongs_to :user
  has_one :post_info
end
```

Create Post

```ruby
post = Post.first
# SELECT "posts".* FROM "posts" LIMIT 1
# => #<Post id: 1, text: "I'm so happy today", user_id: 1, created_at: "2016-04-10 16:55:11", updated_at: "2016-04-10 16:55:11">
```

--

### Creation PostInfo

```ruby
PostInfo.create(post_id: post.id, views: 40, likes: 5, rating: 10)
# INSERT INTO "post_infos" ("created_at", "likes", "post_id", "rating", "updated_at", "views") VALUES (?, ?, ?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["likes", 5], ["post_id", 1], ["rating", 10], ["updated_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["views", 40]]
# => #<PostInfo id: 2, post_id: 1, views: 40, likes: 5, rating: 10, created_at: "2016-04-10 19:50:10", updated_at: "2016-04-10 19:50:10">
```

### Getting using the association

```ruby
post.post_info
# SELECT "post_infos".* FROM "post_infos" WHERE "post_infos"."post_id" = 1 LIMIT 1
# => #<PostInfo id: 1, post_id: 1, views: 40, likes: 5, rating: 10, created_at: "2016-04-10 19:50:10", updated_at: "2016-04-10 19:50:10">
```

### Creation using the association

```ruby
post.create_post_info(views: 40, likes: 5, rating: 10)
# INSERT INTO "post_infos" ("created_at", "likes", "post_id", "rating", "updated_at", "views") VALUES (?, ?, ?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["likes", 5], ["post_id", 1], ["rating", 10], ["updated_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["views", 40]]
# => #<PostInfo id: 1, post_id: 1, views: 40, likes: 5, rating: 10, created_at: "2016-04-10 19:50:10", updated_at: "2016-04-10 19:50:10">
```

---

## has_many :through

![](/assets/images/has_many_through.svg)

--

```bash
$ rails g model Blog title:string description:text
  invoke  active_record
  create    db/migrate/20160410194224_create_blogs.rb
  create    app/models/blog.rb
  invoke    test_unit
  create      test/models/blog_test.rb
  create      test/fixtures/blogs.yml
```

```bash
$ rails g model Subscription user:belongs_to blog:belongs_to receive_news:boolean
  invoke  active_record
  create    db/migrate/20160410194832_create_subscriptions.rb
  create    app/models/subscription.rb
  invoke    test_unit
  create      test/models/subscription_test.rb
  create      test/fixtures/subscriptions.yml
```

```bash
$ rails g migration AddBlogRefToPosts blog:references
  invoke  active_record
  create    db/migrate/20160410195621_add_blog_ref_to_posts.rb
```

--

db/migrate/20160410194224_create_blogs.rb <!-- .element: class="filename" -->

```ruby
class CreateBlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
```

db/migrate/20160410194832_create_subscriptions.rb <!-- .element: class="filename" -->

```ruby
class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :blog, index: true
      t.boolean :receive_news, default: true

      t.timestamps
    end
  end
end
```

db/migrate/20160410195621_add_blog_ref_to_posts.rb <!-- .element: class="filename" -->

```ruby
class AddBlogRefToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :blog, index: true
  end
end
```

--

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ApplicationRecord
  has_many :posts
  has_many :subscriptions
  has_many :blogs, through: :subscriptions
end
```

app/models/blog.rb <!-- .element: class="filename" -->

```ruby
class Blog < ApplicationRecord
  has_many :subscriptions
  has_many :users, through: :subscriptions
end
```

app/models/subscription.rb <!-- .element: class="filename" -->

```ruby
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :blog
end
```

app/models/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  has_one :post_info
end
```

---

## has_one :through

![](/assets/images/has_one_through.svg)

--

```bash
$ rails g model Plan name:string description:text price:decimal{8.2}
invoke  active_record
create    db/migrate/20160410202622_create_plans.rb
create    app/models/plan.rb
invoke    test_unit
create      test/models/plan_test.rb
create      test/fixtures/plans.yml
```

```bash
$ rails g model UserPlan user:belongs_to plan:belongs_to
invoke  active_record
create    db/migrate/20160410203824_create_user_plans.rb
create    app/models/user_plan.rb
invoke    test_unit
create      test/models/user_plan_test.rb
create      test/fixtures/user_plans.yml
```

--

db/migrate/20160410202622_create_plans.rb <!-- .element: class="filename" -->

```ruby
class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
```

db/migrate/20160410203824_create_user_plans.rb <!-- .element: class="filename" -->

```ruby
class CreateUserPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :user_plans do |t|
      t.belongs_to :user, index: true
      t.belongs_to :plan, index: true

      t.timestamps
    end
  end
end
```

--

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ApplicationRecord
  has_many :posts
  has_many :subscriptions
  has_many :blogs, through: :subscriptions
  has_one :user_plan
  has_one :plan, through: :user_plan
end
```

app/models/user_plan.rb <!-- .element: class="filename" -->

```ruby
class UserPlan < ApplicationRecord
  belongs_to :user
  belongs_to :plan
end
```

app/models/plan.rb <!-- .element: class="filename" -->

```ruby
class Plan < ApplicationRecord
  has_many :user_plans
  has_many :users, through: :user_plans
end
```

---

## has_and_belongs_to_many

![](/assets/images/has_and_belongs_to_many.svg)

--

```bash
$ rails g model Tag name:string
  invoke  active_record
  create    db/migrate/20160414211322_create_tags.rb
  create    app/models/tag.rb
  invoke    test_unit
  create      test/models/tag_test.rb
  create      test/fixtures/tags.yml
```

```bash
$ rails g migration create_posts_tags post:references tag:references --no-timestamp
  invoke  active_record
  create    db/migrate/20160414213342_create_posts_tags.rb
```

--

### Rails 4

```ruby
create_join_table :posts, :tags
```
```ruby
create_join_table :posts, :tags, table_name: :tags_for_posts
```
```ruby
create_join_table :posts, :tags, column_options:  {null:  true}
```

db/migrate/20160414213342_create_posts_tags.rb <!-- .element: class="filename" -->

```ruby
class CreatePostsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :posts_tags do |t|
      t.references :post, index: true
      t.references :tag, index: true
    end
  end
end
```

--

#### Change migration. Add common index and remove id.

db/migrate/20160414213342_create_posts_tags.rb <!-- .element: class="filename" -->

```ruby
class CreatePostsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :posts_tags, id: false do |t|
      t.references :post, index: true
      t.references :tag, index: true
    end
    add_index :posts_tags, [:post_id, :tag_id]
  end
end
```

app/models/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
end
```

app/models/tag.rb <!-- .element: class="filename" -->

```ruby
class Tag < ApplicationRecord
  has_and_belongs_to_many :posts
end
```

---

## Polymorphic Associations

![](/assets/images/polymorphic.svg)

--

```bash
$ rails g model Picture imageable:references{polymorphic} file:string
  invoke  active_record
  create    db/migrate/20160414231322_create_pictures.rb
  create    app/models/picture.rb
  invoke    test_unit
  create      test/models/picture_test.rb
  create      test/fixtures/pictures.yml
```

db/migrate/20160414231322_create_pictures.rb <!-- .element: class="filename" -->

```ruby
class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.references :imageable, polymorphic: true, index: true
      t.string :file

      t.timestamps
    end
  end
end
```

--

app/models/picture.rb <!-- .element: class="filename" -->

```ruby
class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end
```

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ApplicationRecord
  has_many :posts
  has_many :subscriptions
  has_many :blogs, through: :subscriptions
  has_one :user_plan
  has_one :plan, through: :user_plan
  has_one :picture, as: :imageable
end
```

app/models/post.rb <!-- .element: class="filename" -->

```ruby
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  has_one :post_info
  has_and_belongs_to_many :tags
  has_many :pictures, as: :imageable
end
```

--

```ruby
user.create_picture(file: 'public/picture/photo.png')
# INSERT INTO "pictures" ("created_at", "file", "imageable_id", "imageable_type", "updated_at") VALUES (?, ?, ?, ?, ?)  [["created_at", Fri, 15 Apr 2016 17:35:01 UTC +00:00], ["file", "public/picture/photo.png"], ["imageable_id", 1], ["imageable_type", "User"], ["updated_at", Fri, 15 Apr 2016 17:35:01 UTC +00:00]]
# => #<Picture id: 1, imageable_id: 1, imageable_type: "User", file: "public/picture/photo.png", created_at: "2016-04-15 17:35:01", updated_at: "2016-04-15 17:35:01">
```

```ruby
post.pictures.create(file: 'public/picture/image.png')
# INSERT INTO "pictures" ("created_at", "file", "imageable_id", "imageable_type", "updated_at") VALUES (?, ?, ?, ?, ?)  [["created_at", Fri, 15 Apr 2016 17:45:21 UTC +00:00], ["file", "public/picture/image.png"], ["imageable_id", 1], ["imageable_type", "Post"], ["updated_at", Fri, 15 Apr 2016 17:45:21 UTC +00:00]]
# => #<Picture id: 2, imageable_id: 1, imageable_type: "Post", file: "public/picture/image.png", created_at: "2016-04-15 17:45:21", updated_at: "2016-04-15 17:45:21">
```

---

# Active Record Validations

---

## When Do Validations Happen?

* `create`
* `create!`
* `save`
* `save!`
* `update`
* `update!`

--

## Skiping Validations

* `decrement!`
* `decrement_counter`
* `increment!`
* `increment_counter`
* `toggle!`
* `touch`
* `update_all`
* `update_attribute`
* `update_column`
* `update_columns`
* `update_counters`

and

`save(validate: false)`

---

## valid? and invalid?

```ruby
class User < ApplicationRecord
  has_many :posts
  validates :email, presence: true
end
```

`valid?`

```ruby
User.new(email: "thebestemail@ua.fm").valid?
# => true

User.new().valid?
# => false
```

--

## Get errors

```ruby
u = User.new
# => #<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>

u.errors
# => #<ActiveModel::Errors:0x00000003001970 @base=#<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>, @messages={}>

u.valid?
# => false

u.errors
# => #<ActiveModel::Errors:0x00000003001970 @base=#<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>, @messages={:email=>["can't be blank"]}>
```

--

## On `create`

```ruby
u = User.create
# => #<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>

u.errors
# => #<ActiveModel::Errors:0x00000003172db8 @base=#<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>, @messages={:email=>["can't be blank"]}>
```

## On `create!`

```ruby
User.create!
# ActiveRecord::RecordInvalid: Validation failed: Email cant be blank
```

## On `save` and `save!`

```ruby
u = User.new
# => #<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>

u.save
# => false

u.save!
# ActiveRecord::RecordInvalid: Validation failed: Email cant be blank
```

---

## `errors[]`

```ruby
> User.new.errors[:email].any?
# => false

> User.create.errors[:email].any?
# => true

> User.create.errors.messages
# => {email:["can't be blank"]}

> User.create.errors.details[:email]
# =>  [{error: :blank}]

> User.create.errors.full_messages
# => ["Email can't be blank"]
```

---

## Presence

```ruby
class User < ApplicationRecord
  attr_accessible :email, :first_name, :password

  has_many :posts
  validates :email, :first_name, presence: true
end
```

```ruby
class Post < ApplicationRecord

  belongs_to :user
  validates :user, presence: true
end
```

```ruby
class User < ApplicationRecord
  attr_accessible :email, :first_name, :password

  has_many :posts, inverse_of: :user
end
```

Can be used for the presence of an object associated validation via a `has_one` or `has_many` relationship, it will check that the object is neither `blank?` nor `marked_for_destruction?`.

```ruby
validates :field_name, inclusion: { in:  [true, false] }. # for fields with boolean type
```


---

## Absence

```ruby
class User < ApplicationRecord
  attr_accessible :email, :first_name, :password

  has_many :posts
  validates :archived, absence: true
end
```

```ruby
class Post < ApplicationRecord
  belongs_to :user
  validates :user, absence: true
end
```

---

## Acceptance

```bash
$ rails g migration AddTermsOfServiceToUsers terms_of_service:boolean
```

```ruby
class User < ApplicationRecord
  # ...

  validates :terms_of_service, acceptance: true  # get accept: 1
end
```

```ruby
class User < ApplicationRecord
  # ...

  validates :terms_of_service, acceptance: { accept: 'yes' }
end
```

---

## Confirmation

```ruby
class User < ApplicationRecord
  # ...

  validates :email, :first_name, presence: true
  validates :email, confirmation: true
end
```

---

## Inclusion

```ruby
class Tag < ApplicationRecord
  # ...

  validates :name, inclusion: { in: %w(reading cooking programming), message: "%{value} is not a valid value" }
end
```

---

## Exclusion

```ruby
class User < ApplicationRecord
  # ...

  validates :first_name, exclusion: { in:  %w(Admin BadDog),  message:  "First name %{value} is reserved." }
end
```

---

## Format

```ruby
class User < ApplicationRecord
  # ...

  validates :email, :first_name, presence: true
  validates :email, confirmation: true
  validates :email, format: { with: /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/, message: 'Only emails allowed' }
  validates :email, format: { without: /test.com$/, message: 'Test emails are not allowed' } #default message "is invalid"
end
```

---

## Length

```bash
$ rails g migration AddCardNumberToUsers card_number:string
```

```ruby
class User < ApplicationRecord
  # ...

  validates :first_name, length: {
    minimum: 2,
    maximum: 500,
    wrong_length: 'Invalid length',
    too_long: "%{count} characters is the maximum allowed"
    too_short: "must have at least %{count} characters"
  }

  validates :password, length: { in: 6..20 }
  validates :card_number, length:  { is: 14 }
end
```

* `:minimum` – The attribute cannot have less than the specified length.
* `:maximum` – The attribute cannot have more than the specified length.
* `:in` (or `:within`) – The attribute length must be included in a given interval.
<br>The value for this option must be a range.
* `:is` – The attribute length must be equal to the given value.

---

## Numericality
```ruby
class PostInfo < ApplicationRecord
  # ...

  validates :views, numericality: true
  validates :rate, numericality: { only_integer: true, greater_than: 5 }
end
```

* `:greater_than`
* `:greater_than_or_equal_to`
* `:equal_to`
* `:less_than`
* `:less_than_or_equal_to`
* `:odd`
* `:even`

By default, numericality doesn't allow `nil` values. You can use `allow_nil: true` option to permit it.

---

## Uniqueness

```bash
$ rails g AddPageAddressToUsers page_address:string
```

```ruby
class User < ApplicationRecord
  # ...

  validates :email, uniqueness: true
  validates :first_name, uniqueness: { scope: :email,  message: 'should only one user with name and email' }
  validates :page_address, uniqueness: { case_sensitive:  false }
end
```

---

## Validates Assosiated

```ruby
class User < ApplicationRecord
  # ...

  has_many :posts
  validates_associated :posts
end
```

---

## validates_with

```ruby
class User < ApplicationRecord
  validates_with GoodnessValidator
end
 
class GoodnessValidator < ActiveModel::Validator
  def validate(record)
    if record.first_name == 'Evil'
      record.errors[:base] << 'This user is evil'
    end
  end
end
```

```ruby
class User < ApplicationRecord
  validates_with GoodnessValidator, fields: [:first_name, :last_name]
end

class GoodnessValidator < ActiveModel::Validator
  def validate(record)
    if options[:fields].any?{|field| record.send(field) == 'Evil' }
      record.errors[:base] << 'This user is evil'
    end
  end
end
```

---

## validate_each

```ruby
class User < ApplicationRecord
  validates_each :first_name, :last_name do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[a-z]/
  end
end
```

---

## General options

```ruby
class Post < ApplicationRecord
  validates :title, allow_nil: true
end
```

```ruby
class User < ApplicationRecord
  validates :last_name, allow_blank: true
end
```

```ruby
class User < ApplicationRecord
  validates :last_name, presence: { message: "is mandatory" }
  validates :age, numericality: { message: "%{attribute} for %{model} has %{value} that seems wrong" }

  # Proc
  validates :username,
    uniqueness: {
      # object = person object being validated
      # data = { model: "User", attribute: "Username", value: <username> }
      message: ->(object, data) do
        "Hey #{object.name}!, #{data[:value]} is taken already! Try again #{Time.zone.tomorrow}"
      end
    }
end
```

--

## General options

`:allow_nil` and `:allow_blank` are ignored by `:presence`

```ruby
class User < ApplicationRecord
  # it will be possible to update email with a duplicated value
  validates :email, uniqueness: true, on: :create

  # it will be possible to create the record with a non-numerical age
  validates :card_number, numericality: true, on: :update

  # the default (validates on both create and update)
  validates :first_name, presence: true, on: :save

  validates :email, uniqueness: true, on: :registration
  #Custom contexts need to be triggered explicitly by passing name of the context to valid?, invalid? or save.
end
```

---

## Strict validations

```ruby
class User < ApplicationRecord
  attr_accessible :email, :first_name, :password

  has_many :posts
  validates :email, presence: { strict: true }
end
```

```ruby
User.new.valid?  # => ActiveModel::StrictValidationFailed: "Email can't be blank"
```

---

## Condional validations

```ruby
class User < ApplicationRecord
  validates :card_number, presence: true, if: :paid_with_card?

  def paid_with_card?
    payment_type == 'card'
  end
end
```

```ruby
validates :last_name, presence: true, if: 'first_name.nil?'
```

```ruby
validates :password, confirmation: true, unless: Proc.new { |a| a.password.blank? }
```

```ruby
with_options if: :is_admin? do |admin|
  admin.validates :password, length: { minimum: 10 }
  admin.validates :email, presence: true
end
```

```ruby
class User < ApplicationRecord
  validates :password, confirmation: true, if: ['editor?', :api_user?], unless: Proc.new { |u| u.admin? }
end
```

---

## Custom Validators

```ruby
class MyValidator < ActiveModel::Validator
  def validate(record)
    unless record.first_name.starts_with? 'X'
      record.errors[:first_name] << 'Need a name starting with X please!'
    end
  end
end

class User
  include ActiveModel::Validations
  validates_with MyValidator
end
```

```ruby
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || 'is not an email')
    end
  end
end

class User < ActiveRecord::Base
  validates :email, presence: true, email: true
end
```

---

## Custom Methods

```bash
$ rails g model Payment discount:decimal{8.2} total_value:decimal{8.2} expiration_date:date
```

```ruby
class Payment < ActiveRecord::Base
  belongs_to :user_plan
  validate :expiration_date_cannot_be_in_the_past,
    :discount_cannot_be_greater_than_total_value

  def expiration_date_cannot_be_in_the_past
    if !expiration_date.blank? and expiration_date < Date.today
      errors.add(:expiration_date, "can't be in the past")
    end
  end

  def discount_cannot_be_greater_than_total_value
    if discount > total_value
      errors.add(:discount, "can't be greater than total value")
    end
  end
end
```

---

## Validation Errors

```ruby
class User < ApplicationRecord
  def a_method_used_for_validation_purposes
    errors.add(:first_name, "cannot contain the characters !@#%*()_-+=")
    # errors[:first_name] = "cannot contain the characters !@#%*()_-+="
  end
end
```

```ruby
user = User.create(first_name: '!@#')
user.errors[:first_name] # => ["cannot contain the characters !@#%*()_-+="]
user.errors.full_messages  # => ["Name cannot contain the characters !@#%*()_-+="]
```

```ruby
class User < ApplicationRecord
  def a_method_used_for_validation_purposes
    errors[:base] << 'This user is invalid because ...'
  end
end
```

```ruby
errors.clear
```

```ruby
errors.size
```

---

# Active Record Callbacks

---

## Callback registrations

```bash
$ rails g migration AddLoginToUsers login:string
```

```ruby
class User < ApplicationRecord
  # ...

  validates :login, :email, presence: true

  before_validation :ensure_login_has_a_value

  before_create do |user|
    user.first_name = user.login.capitalize if user.first_name.blank?
  end

  protected

  def ensure_login_has_a_value
    if login.nil?
      self.login = email unless email.blank?
    end
  end
end
```

---

## Availiable Callbacks

### Creating an Object

* `before_validation`
* `after_validation`
* `before_save`
* `around_save`
* `before_create`
* `around_create`
* `after_create`
* `after_save`
* `after_commit/after_rollback`

--

### Updating an Object

* `before_validation`
* `after_validation`
* `before_save`
* `around_save`
* `before_update`
* `around_update`
* `after_update`
* `after_save`
* `after_commit/after_rollback`

--

### Destroying an Object

* `before_destroy`
* `around_destroy`
* `after_destroy`
* `after_commit/after_rollback`

---

## `after_find` and `after_initialize`

```ruby
class User < ApplicationRecord
  after_initialize do |user|
    puts 'You have initialized an object!'
  end

  after_find do |user|
    puts 'You have found an object!'
  end
end

User.new
# You have initialized an object!
# => #<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false>

User.first
# You have found an object!
# You have initialized an object!
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>
```

--

## `after_touch`

```ruby
class User < ApplicationRecord
  after_touch do |user|
    puts 'You have touched an object'
  end
end

u = User.create(name: 'Martin')
# => #<User id: 1, name: "Martin", created_at: "2016-04-14 21:17:49", updated_at: "2016-04-14 21:17:49">

u.touch
# You have touched an object
# => true
```

--

## `after_touch`

```ruby
class Post < ApplicationRecord
  belongs_to :user, touch: true
  after_touch do
    puts 'An Post was touched'
  end
end

class User < ApplicationRecord
  has_many :posts
  after_touch :notify

  private

  def notify
    puts 'User was touched'
  end
end

@post = Post.last
# => #<Post id: 1, user_id: 1, created_at: "2016-04-15 17:08:32", updated_at:  "2016-04-15 17:08:32">

# triggers @post.user.touch
@post.touch
# User was touched
# An Post was touched
# => true
```

---

## Running Callbacks

* `create`
* `create!`
* `decrement!`
* `destroy`
* `destroy!`
* `destroy_all`
* `increment!`
* `save`
* `save!`
* `save(validate: false)`
* `toggle!`
* `update`
* `update_attribute`
* `update`
* `update!`
* `valid?`

---

## after_find

* `all`
* `first`
* `find`
* `find_by_*`
* `find_by_*!`
* `find_by_sql`
* `last`

---

## Skipping callbacks

* `decrement`
* `decrement_counter`
* `delete`
* `delete_all`
* `increment`
* `increment_counter`
* `toggle`
* `touch`
* `update_column`
* `update_columns`
* `update_all`
* `update_counters`

The whole callback chain is wrapped in a transaction. If any before callback method returns exactly false or raises an
exception, the execution chain gets halted and a ROLLBACK is issued; after callbacks can only accomplish that by
raising an exception.

---

## Relational Callbacks

```ruby
class User < ApplicationRecord
  # ...

  has_many :posts, dependent: :destroy
end

class Post < ApplicationRecord
  # ...

  after_destroy :log_destroy_action

  def log_destroy_action
    puts 'Post destroyed'
  end
end
```

```ruby
user = User.first
# => #<User id: 1>

user.posts.create!
# => #<Post id: 1, user_id: 1>

user.destroy
# Post destroyed
# => #<User id: 1>
```

---

## Conditional Callbacks

```ruby
before_save :normalize_card_number, if: :paid_with_card?
before_save :normalize_card_number, if: "paid_with_card?"
before_save :normalize_card_number, if: Proc.new { |order| order.paid_with_card? }
after_create :send_email_to_user,   if: :user_wants_emails?, unless: Proc.new { |comment| comment.post.ignore_comments? }
```

---

## Callback Classes

```ruby
class PictureFileCallbacks
  def after_destroy(picture_file)
    if File.exists?(picture_file.filepath)
      File.delete(picture_file.filepath)
    end
  end
end
```

```ruby
class PictureFile < ApplicationRecord
  after_destroy PictureFileCallbacks.new
end
```

```ruby
class PictureFileCallbacks
  def self.after_destroy(picture_file)
    if File.exists?(picture_file.filepath)
      File.delete(picture_file.filepath)
    end
  end
end
```

```ruby
class PictureFile < ApplicationRecord
  after_destroy PictureFileCallbacks
end
```

---

## Transaction Callbacks

* `after_commit`
* `after_rollback`

```ruby
PictureFile.transaction do
  picture_file_1.destroy
  picture_file_2.save!
end
```

```ruby
class PictureFile < ApplicationRecord
  after_commit :delete_picture_file_from_disk, on: [:destroy]

  def delete_picture_file_from_disk
    if File.exist?(filepath)
      File.delete(filepath)
    end
  end
end
```

* `after_create_commit`
* `after_update_commit`
* `after_destroy_commit`

---

# Query Interface

---

## Retrieving Objects from the Database

### ActiveRecord::Relation

<div>
* `find`
* `create_with`
* `distinct`
* `eager_load`
* `extending`
* `from`
* `group`
* `having`
* `includes`
* `joins`
* `left_outer_joins`
* `limit`
</div><!-- .element: class="left width-50" -->

<div>
* `lock`
* `none`
* `offset`
* `order`
* `preload`
* `readonly`
* `references`
* `reorder`
* `reverse_order`
* `select`
* `where`
</div><!-- .element: class="right width-50" -->

---

## Retrieving a Single Object

Using a Primary Key

```ruby
User.find(1)
# User Load (0.4ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>
```

`take`

```ruby
User.take
# User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 1
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>
```

`first`

```ruby
User.first
# User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>
```

`last`

```ruby
User.last
# User Load (0.5ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
# => #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>
```

`take`, `first`, `last`, `find_by` returns `nil` if no matching record is found and no exception will be raised.
`take!`, `first!`, `last!`, `find_by!` raise `ActiveRecord::RecordNotFound` if no matching record is found.

--

`find_by`

```ruby
User.find_by first_name: "Anna"
# User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."first_name" = 'Anna' LIMIT 1
# => #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>
```

```ruby
User.find_by first_name: "Anna", email: "some@ua.fm"
# User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."first_name" = 'Anna' AND "users"."email" = 'some@ua.fm' LIMIT 1
# => nil
```

---

## Retrieving Multiple Objects

Using Multiple Primary Keys

```ruby
User.find([1, 2]) # User.find(1, 2)
# User Load (0.7ms)  SELECT "users".* FROM "users" WHERE "users"."id" IN (1, 2)
# => [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]
```

`take`

```ruby
User.take(2)
# User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 2
# => [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]
```

`first`

```ruby
User.first(2)
# User Load (0.5ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 2
# => [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]
```

`last`

```ruby
User.last(2)
# User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 2
# => [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]
```

---

## Retrieving Multiple Objects in Batches

```ruby
User.all.each do |user|
  puts user.first_name
end
# User Load (0.5ms)  SELECT "users".* FROM "users"
# Anna
# Vanka
# => [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]
```

`find_each`

```ruby
User.find_each do |user|
  puts user.first_name
end
# User Load (0.7ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1000
# Anna
# Vanka
# => nil
```

--

`:batch_size`

```ruby
User.find_each(batch_size: 1) do |user|
  puts user.first_name
end
# User Load (0.3ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
# Anna
# User Load (0.2ms)  SELECT "users".* FROM "users" WHERE ("users"."id" > 1) ORDER BY "users"."id" ASC LIMIT 1
# Vanka
# User Load (0.1ms)  SELECT "users".* FROM "users" WHERE ("users"."id" > 2) ORDER BY "users"."id" ASC LIMIT 1
# => nil
```

`:start`

```ruby
User.find_each(start: 2, batch_size: 1) do |user|
  puts user.first_name
end
# User Load (0.7ms)  SELECT "users".* FROM "users" WHERE ("users"."id" >= 2) ORDER BY "users"."id" ASC LIMIT 1
# Vanka
# User Load (0.6ms)  SELECT "users".* FROM "users" WHERE ("users"."id" > 2) ORDER BY "users"."id" ASC LIMIT 1
# => nil
```

`find_in_batches`

```ruby
Post.find_in_batches(include: :tags) do |posts|
  puts posts.map(&:tags)
end
# Post Load (0.5ms)  SELECT "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT 1000
# SQL (0.5ms)  SELECT "tags".*, "t0"."post_id" AS ar_association_key_name FROM "tags" INNER JOIN "posts_tags" "t0" ON "tags"."id" = "t0"."tag_id" WHERE "t0"."post_id" IN (1, 2)
# #<Tag:0x00000004920618>
```

---

## Conditions

String conditions

```ruby
User.where('first_name = 'Anna'')
# User Load (0.4ms)  SELECT "users".* FROM "users" WHERE (first_name = 'Anna')
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>]>
```

Array conditions

```ruby
User.where('email = ?', params[:email])
```

```ruby
User.where('last_name = ? AND receive_news = ?', params[:last_name], true)
```

Placeholder conditions

```ruby
Payment.where('created_at >= :start_date', { start_date: 10.days.ago })
# Payment Load (0.1ms)  SELECT "payments".* FROM "payments" WHERE (created_at >= '2013-06-13 18:56:01.086812')
# => #<ActiveRecord::Relation []>
```

--

Hash conditions

```ruby
User.where(first_name: 'Anna')
```

```ruby
User.where('first_name' => 'Anna')
```

```ruby
Post.where(user: User.first)
# SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = 1
# => #<ActiveRecord::Relation []>
```

Range conditions

```ruby
User.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
# User Load (0.5ms)  SELECT "users".* FROM "users" WHERE ("users"."created_at" BETWEEN '2013-06-21 21:00:00.000000' AND '2013-06-22 21:00:00.000000')
# => #<ActiveRecord::Relation []>
```

Subset conditions

```ruby
Tag.where(name: ['cooking', 'programming'])
# SELECT "tags".* FROM "tags" WHERE "tags"."name" IN ('cooking', 'programming')
# => #<ActiveRecord::Relation []>
```

NOT conditions

```ruby
Post.where.not(user: User.first)
# User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
# Post Load (0.2ms)  SELECT "posts".* FROM "posts" WHERE ("posts"."user_id" != 1)
# => #<ActiveRecord::Relation []>
```

---

## Ordering

```bash
User.order("created_at")
# SELECT "users".* FROM "users" ORDER BY created_at
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

ASC, DESC
```ruby
User.order('created_at ASC')
```

```ruby
User.order('created_at DESC')
```

Ordering by multiple fields

```ruby
User.order('id ASC,created_at DESC')
```

```ruby
User.order('id ASC').order('created_at DESC')
```

---

## Selecting

```ruby
User.select('first_name, email')
# User Load (0.4ms)  SELECT first_name, email FROM "users"
# => #<ActiveRecord::Relation [#<User id: nil, first_name: "Anna", email: "happy_ann@gmail.com">, #<User id: nil, first_name: "Van'ka", email: "vanka@yandex.ru">]>
```

```ruby
User.select('status')
# User Load (0.6ms)  SELECT status FROM "users"
# SQLite3::SQLException: no such column: status: SELECT status FROM "users"
# ActiveRecord::StatementInvalid: SQLite3::SQLException: no such column: status: SELECT status FROM "users"
```

## distinct

```ruby
User.select(:first_name).distinct
# User Load (0.5ms)  SELECT DISTINCT first_name FROM "users"
# => #<ActiveRecord::Relation [#<User id: nil, first_name: "Anna">, #<User id: nil, first_name: "Van'ka">]>
```

```ruby
query = User.select(:name).distinct
query.distinct(false)
```

---

## Limit and Offset

### limit

```ruby
User.limit(5)
# User Load (0.6ms)  SELECT "users".* FROM "users" LIMIT 5
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

### offset

```ruby
User.limit(5).offset(1)
# User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 5 OFFSET 1
# => #<ActiveRecord::Relation [#<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

---

## Group

```ruby
p = PostInfo.select('id, sum(views) AS sum_views').group('post_id')
# PostInfo Load (0.5ms)  SELECT id, sum(views) AS sum_views FROM "post_infos" GROUP BY post_id
# => #<ActiveRecord::Relation [#<PostInfo id: 1>, #<PostInfo id: 2>]>

p.each{ |p| puts p.sum_views }
# => [#<PostInfo id: 1>, #<PostInfo id: 2>]
```

---

## Having

```ruby
p = PostInfo.select('id, sum(views) AS sum_views').group('post_id').having('sum(views) > 5')
# PostInfo Load (0.5ms)  SELECT id, sum(views) AS sum_views FROM "post_infos" GROUP BY post_id HAVING sum(views) > 5
# => #<ActiveRecord::Relation [#<PostInfo id: 1>]>

p.each{ |p| puts p.sum_views }
# => [#<PostInfo id: 1>]
```

---

## Overriding Conditions

except

```ruby
Post.where('id > 2').limit(2).except(:limit)
# Post Load (0.5ms)  SELECT "posts".* FROM "posts" WHERE (id > 2)
# => #<ActiveRecord::Relation [#<Post id: 3, text: "New post", user_id: 1, created_at: "2013-06-02 19:06:35", updated_at: "2013-06-02 19:06:35", title: nil, published: nil>, #<Post id: 4, text: "Some text", user_id: 2, created_at: "2013-06-23 20:18:11", updated_at: "2013-06-23 20:18:11", title: "First step", published: nil>]>
```

unscope

```ruby
Post.order('id DESC').limit(20).unscope(:order) # == Post.limit(20)
Post.order('id DESC').limit(20).unscope(:order, :limit) # == Post.all
```

only

```ruby
Post.where('id > 2').limit(2).order('id desc')
# Post Load (0.5ms)  SELECT "posts".* FROM "posts" WHERE (id > 2) ORDER BY id desc LIMIT 2
# => #<ActiveRecord::Relation [#<Post id: 5, text: "Some another text", user_id: 2, created_at: "2013-06-23 20:18:23", updated_at: "2013-06-23 20:18:23", title: "First step", published: nil>, #<Post id: 4, text: "Some text", user_id: 2, created_at: "2013-06-23 20:18:11", updated_at: "2013-06-23 20:18:11", title: "First step", published: nil>]>
```

```ruby
Post.where('id > 2').limit(2).order('id desc').only(:order, :where)
# Post Load (0.5ms)  SELECT "posts".* FROM "posts" WHERE (id > 2) ORDER BY id desc
# => #<ActiveRecord::Relation [#<Post id: 5, text: "Some another text", user_id: 2, created_at: "2013-06-23 20:18:23", updated_at: "2013-06-23 20:18:23", title: "First step", published: nil>, #<Post id: 4, text: "Some text", user_id: 2, created_at: "2013-06-23 20:18:11", updated_at: "2013-06-23 20:18:11", title: "First step", published: nil>, #<Post id: 3, text: "New post", user_id: 1, created_at: "2013-06-02 19:06:35", updated_at: "2013-06-02 19:06:35", title: nil, published: nil>]>
```

--

reorder

```ruby
class User <  ApplicationRecord
  # ...

  has_many :posts, -> { order('created_at DESC') }
end
```

```ruby
User.find(2).posts.reorder('title')
# User Load (0.3ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 2]]
# Post Load (0.6ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ? ORDER BY title  [["user_id", 2]]
# => #<ActiveRecord::Relation [#<Post id: 4, text: "Some text", user_id: 2, created_at: "2013-06-23 20:18:11", updated_at: "2013-06-23 20:18:11", title: "First step", published: nil>, #<Post id: 5, text: "Some another text", user_id: 2, created_at: "2013-06-23 20:18:23", updated_at: "2013-06">]
```

reverse_order

```ruby
User.order(:created_at)
# User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users".created_at ASC
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

```ruby
User.order(:created_at).reverse_order
# User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users".created_at DESC
# => #<ActiveRecord::Relation [#<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>, #<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-02 17:23:02", last_name: nil, receive_news: false>]>
```

rewhere

```ruby
User.where(admin: true).rewhere(admin: false)
# SELECT * FROM users WHERE `admin` = 0
```

```ruby
User.where(admin: true).where(admin: false)
# SELECT * FROM users WHERE `admin` = 1 AND `admin` = 0
```

---

## Null Relation

```ruby
Post.none # returns an empty Relation and fires no queries.
```

```ruby
# The visible_posts method below is expected to return a Relation.
@posts = current_user.visible_posts.where(title: params[:title])

def visible_posts
  case role
  when 'Reviewer'
    Post.published
  when 'Bad User'
    Post.none
  end
end
```

---

## Readonly

```ruby
user = User.readonly.first
user.first_name = 'Anny'
user.save

# ActiveRecord::ReadOnlyRecord: ActiveRecord::ReadOnlyRecord
```

---

## Locking Records for Update

### Optimistic locking
Optimistic locking allows multiple users to access the same record for edits, and assumes a minimum of conflicts with
the data. It does this by checking whether another process has made changes to a record since it was opened, an
`ActiveRecord::StaleObjectError` exception is thrown if that has occurred and the update is ignored.
`lock_version` field should present. Each update to the record increments the `lock_version` column and the locking
facilities ensure that records instantiated twice will let the last one saved raise a `StaleObjectError` if the first was
also updated.

```ruby
u1 = User.find(1)
u2 = User.find(1)
u1.first_name = 'Michael'
u1.save
u2.first_name = 'should fail'
u2.save # Raises an ActiveRecord::StaleObjectError
```

---

## Locking Records for Update

### Pessimistic locking

It provides support for row-level locking using `SELECT … FOR UPDATE` and other lock types.

```ruby
User.transaction do
  user = User.find(1, lock: true)
  user.first_name = 'Marta'
  user.save
end
```

---

## Joining Tables

Using a String SQL Fragmen

```ruby
users = User.joins('LEFT OUTER JOIN posts ON posts.user_id = users.id')
# User Load (0.3ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN posts ON posts.user_id = users.id
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

```ruby
users.length
# User Load (0.7ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN posts ON posts.user_id = users.id
# => 5
```

```ruby
Post.all.length
# Post Load (0.5ms)  SELECT "posts".* FROM "posts"
# => 5
```

left_outer_joins

```ruby
User.left_outer_joins(:posts).distinct
# User Load (1.4ms)  SELECT DISTINCT "users".* FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

--

Joining a Single Association

```ruby
User.joins(:posts)
# User Load (0.5ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id"
```

Joining Multiple Associations

```ruby
Post.joins(:tags, :blog)
# Post Load (0.6ms)  SELECT "posts".* FROM "posts" INNER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" INNER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" INNER JOIN "blogs" ON "blogs"."id" = "posts"."blog_id"
# => #<ActiveRecord::Relation [#<Post id: 5, text: "Some another text", user_id: 2, created_at: "2013-06-23 20:18:23", updated_at: "2013-06-23 21:24:37", title: "First step", published: nil, blog_id: 1>]>
```

Joining Nested Associations (Single Level)

```ruby
Post.joins(blog: :users)
# Post Load (0.2ms)  SELECT "posts".* FROM "posts" INNER JOIN "blogs" ON "blogs"."id" = "posts"."blog_id" INNER JOIN "subscriptions" ON "subscriptions"."blog_id" = "blogs"."id" INNER JOIN "users" ON "users"."id" = "subscriptions"."user_id"
```

Joining Nested Associations (Multiple Level)

```ruby
User.joins(posts: [{blog: :subscriptions}, :tags])
# User Load (0.8ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" INNER JOIN "blogs" ON "blogs"."id" = "posts"."blog_id" INNER JOIN "subscriptions" ON "subscriptions"."blog_id" = "blogs"."id" INNER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" INNER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" WHERE "users"."state" = 'pending'
```

Specifying Conditions on the Joined Tables

```ruby
User.joins(:posts).where('posts.created_at' => (Time.now.midnight - 1.day)..Time.now.midnight)
# User Load (0.5ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE ("posts"."created_at" BETWEEN '2013-06-22 21:00:00.000000' AND '2013-06-23 21:00:00.000000')
# => #<ActiveRecord::Relation [#<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
```

---

## Eager Loading Associations

```ruby
users = User.limit(10)

users.each do |user|
  puts user.posts.map(&:title)
end

# User Load (0.6ms)  SELECT "users".* FROM "users" LIMIT 10
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
# Post Load (0.6ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ?  [["user_id", 1]]
# =>
# Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ?  [["user_id", 2]]
#
# => First step
# First step
```

```ruby
users = User.includes(:posts).limit(10)

users.each do |user|
  puts user.posts.map(&:title)
end

# User Load (0.6ms)  SELECT "users".* FROM "users" LIMIT 10
# Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (1, 2)
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]>
# =>
# =>  First step
# First step
# => [#<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>, #<User id: 2, first_name: "Van'ka", email: "vanka@yandex.ru", password: nil, created_at: "2013-06-02 18:18:40", updated_at: "2013-06-02 18:20:00", last_name: nil, receive_news: false>]
```

--

Array of Multiple Associations

```ruby
p =  Post.includes(:blog, :tags)
# Post Load (0.5ms)  SELECT "posts".* FROM "posts"
# Blog Load (0.3ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."id" IN (1)
# SQL (0.3ms)  SELECT "tags".*, "t0"."post_id" AS ar_association_key_name FROM "tags" INNER JOIN "posts_tags" "t0" ON "tags"."id" = "t0"."tag_id" WHERE "t0"."post_id" IN (1, 2, 3, 4, 5)
# => #<ActiveRecord::Relation [#<Post id: 1, text: "I'm so happy today", user_id: 1, created_at: "2013-06-02 18:43:10", updated_at: "2013-06-02 18:43:10", title: nil, published: nil, blog_id: nil>, #<Post id: 2, text: "I'm waiting", user_id: 1, created_at: "2013-06-02 19:01:45", updated_at: "2013-06-02 19:01:45", title: nil, published: nil, blog_id: nil>, #<Post id: 3, text: "New post", user_id: 1, created_at: "2013-06-02 19:06:35", updated_at: "2013-06-02 19:06:35", title: nil, published: nil, blog_id: nil>, #<Post id: 4, text: "Some text", user_id: 2, created_at: "2013-06-23 20:18:11", updated_at: "2013-06-23 20:18:11", title: "First step", published: nil, blog_id: nil>, #<Post id: 5, text: "Some another text", user_id: 2, created_at: "2013-06-23 20:18:23", updated_at: "2013-06-23 21:24:37", title: "First step", published: nil, blog_id: 1>]>
```

```ruby
p.first.tags
# => #<ActiveRecord::Associations::CollectionProxy []>
```

Nested Associations Hash

```ruby
User.includes([:subscriptions, {:posts => [:tags]}]).find(1)
# User Load (1.9ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
# Subscription Load (0.1ms)  SELECT "subscriptions".* FROM "subscriptions" WHERE "subscriptions"."user_id" IN (1)
# Post Load (0.2ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (1)
# SQL (0.2ms)  SELECT "tags".*, "t0"."post_id" AS ar_association_key_name FROM "tags" INNER JOIN "posts_tags" "t0" ON "tags"."id" = "t0"."tag_id" WHERE "t0"."post_id" IN (1, 2, 3)
# => #<User id: 1, first_name: "Marta", email: "happy_ann@gmail.com", password: nil, created_at: "2013-06-02 17:23:02", updated_at: "2013-06-23 21:02:23", last_name: nil, receive_news: false>
```

--

Specifying Conditions on Eager Loaded Associations

```ruby
p = Post.includes(:tags).where("tags.name != 'nil'")
# SQL (0.7ms)  SELECT "posts"."id" AS t0_r0, "posts"."text" AS t0_r1, "posts"."user_id" AS t0_r2, "posts"."created_at" AS t0_r3, "posts"."updated_at" AS t0_r4, "posts"."title" AS t0_r5, "posts"."published" AS t0_r6, "posts"."blog_id" AS t0_r7, "tags"."id" AS t1_r0, "tags"."name" AS t1_r1, "tags"."created_at" AS t1_r2, "tags"."updated_at" AS t1_r3 FROM "posts" LEFT OUTER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" LEFT OUTER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" WHERE (tags.name != 'nil')
# => #<ActiveRecord::Relation [#<Post id: 5, text: "Some another text", user_id: 2, created_at: "2013-06-23 20:18:23", updated_at: "2013-06-23 21:24:37", title: "First step", published: nil, blog_id: 1>]>
```

```ruby
p.first.tags
# => #<ActiveRecord::Associations::CollectionProxy [#<Tag id: 1, name: "good", created_at: "2013-06-23 21:25:07", updated_at: "2013-06-23 21:25:07">]>
```

```ruby
p = Post.includes(:tags).where("tags.name != 'nil'").references(:tags)
# SQL (0.7ms)  SELECT "posts"."id" AS t0_r0, "posts"."text" AS t0_r1, "posts"."user_id" AS t0_r2, "posts"."created_at" AS t0_r3, "posts"."updated_at" AS t0_r4, "posts"."title" AS t0_r5, "posts"."published" AS t0_r6, "posts"."blog_id" AS t0_r7, "tags"."id" AS t1_r0, "tags"."name" AS t1_r1, "tags"."created_at" AS t1_r2, "tags"."updated_at" AS t1_r3 FROM "posts" LEFT OUTER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" LEFT OUTER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" WHERE (tags.name != 'nil')
```

---

## Scopes

```ruby
class Post < ApplicationRecord
  # ...

  scope :published, -> { where(published: true) }
end
```

```ruby
class Post < ApplicationRecord
  # ...

  def self.published
    where(published: true)
  end
end
```

```ruby
class Post < ApplicationRecord
  scope :published, -> { where(published: true) }
  scope :published_with_tags, -> { published.where('tags_count > 0') }
end
```

```ruby
Post.published
```

```ruby
Tags.first.posts.published
```

--

Passing in arguments

```ruby
class Post < ApplicationRecord
  # ...

  scope :created_before, ->(time) { where("created_at < ?", time) }
end
```

```ruby
Post.created_before(Time.now)
```

Merging of scopes

```bash
$ rails g migration AddStateToUser state:string
```

```ruby
class User < ApplicationRecord
  scope :active, -> { where state: 'active' }
  scope :inactive, -> { where state: 'inactive' }
end
```

```bash
User.active.inactive
# User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'active' AND "users"."state" = 'inactive'
```

```bash
User.active.where(state: 'finished')
# User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'active' AND "users"."state" = 'finished'
```

If we want the last where clause to win

```bash
User.active.merge(User.inactive)
# User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'inactive'
```

--

`default_scope` - will be applied across all queries - will be overridden by scope and where conditions

```ruby
class User < ApplicationRecord
  default_scope { where state: 'pending' }
  scope :active, -> { where state: 'active' }
  scope :inactive, -> { where state: 'inactive' }
end
```

```bash
User.all
# User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending'
```

```bash
User.active
# User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'active'
```

```bash
User.where(state: 'inactive')
# User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'inactive'
```

Removing All Scoping

```bash
User.unscoped.all
# SELECT "users".* FROM "users"
```

---

## Dynamic finders

For every field (also known as an attribute) you define in your table, Active Record provides a finder method. If you have a field called `first_name` on your `Client` model for example, you get `find_by_first_name` for free from Active Record. If you have a locked field on the `Client` model, you also get `find_by_locked` method.

You can specify an exclamation point (!) on the end of the dynamic finders to get them to raise an `ActiveRecord::RecordNotFound` error if they do not return any records, like `Client.find_by_name!('Ryan')`

If you want to find both by name and locked, you can chain these finders together by simply typing "and" between the fields. For example, `Client.find_by_first_name_and_locked('Ryan', true)`.

---

## Find or Build a New Object

find_or_create_by

```bash
User.find_or_create_by(first_name: 'Mark')
# User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending' AND "users"."first_name" = 'Mark' LIMIT 1
# (0.3ms)  begin transaction
# SQL (3.8ms)  INSERT INTO "users" ("created_at", "first_name", "state", "updated_at") VALUES (?, ?, ?, ?)  [["created_at", Mon, 24 Jun 2013 09:26:43 UTC +00:00], ["first_name", "Mark"], ["state", "pending"], ["updated_at", Mon, 24 Jun 2013 09:26:43 UTC +00:00]]
# (134.1ms)  commit transaction
# => #<User id: 3, first_name: "Mark", email: nil, password: nil, created_at: "2013-06-24 09:26:43", updated_at: "2013-06-24 09:26:43", last_name: nil, receive_news: false, state: "pending">

User.find_or_create_by(first_name: 'Mark')
# User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending' AND "users"."first_name" = 'Mark' LIMIT 1
# => #<User id: 3, first_name: "Mark", email: nil, password: nil, created_at: "2013-06-24 09:26:43", updated_at: "2013-06-24 09:26:43", last_name: nil, receive_news: false, state: "pending">
```

```bash
User.find_or_create_by(first_name: 'Andy') { |c| c.locked = false }
```

find_or_initialize_by

```bash
clark = User.find_or_initialize_by(first_name: 'Clark')
# User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending' AND "users"."first_name" = 'Clark' LIMIT 1
# => #<User id: nil, first_name: "Clark", email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false, state: "pending">

clark.persisted?
# => false

clark.new_record?
# => true

clark.save
```

---

## Finding by SQL

find_by_sql

```ruby
User.find_by_sql("SELECT * FROM users INNER JOIN posts ON users.id = posts.user_id")
# User Load (0.7ms)  SELECT * FROM users INNER JOIN posts ON users.id = posts.user_id
# => [#<User id: 1, first_name: "Anna", email: "ann@ua.fm", password: "111111", created_at: "2013-06-24 08:54:47", updated_at: "2013-06-24 08:54:47", last_name: nil, receive_news: true, state: "active">, #<User id: 2, first_name: "Gregory", email: "greg@ua.fm", password: "111111", created_at: "2013-06-24 08:55:25", updated_at: "2013-06-24 08:55:25", last_name: "Taunsend", receive_news: false, state: "inactive">]
```

select_all

```ruby
Post.connection.select_all("SELECT * FROM posts WHERE id = '1'")
# (0.5ms)  SELECT * FROM posts WHERE id = '1'
# => #<ActiveRecord::Result:0x0000000398efb0 @columns=["id", "text", "user_id", "created_at", "updated_at", "title", "published", "blog_id"], @rows=[[1, "Every trip begins with the first step", 1, "2013-06-24 08:54:47.619258", "2013-06-24 08:54:47.619258", "1000 miles", nil, nil]], @hash_rows=nil, @column_types={}>
```

pluck

```ruby
User.where(state: "active").pluck(:id)
# (0.5ms)  SELECT "users"."id" FROM "users" WHERE "users"."state" = 'active'
# => [1]
```

```ruby
User.distinct.pluck(:first_name)
# (0.5ms)  SELECT DISTINCT "users"."first_name" FROM "users" WHERE "users"."state" = 'pending'
# => ["Mark", "Alice"]
```

```ruby
User.pluck(:id, :first_name)
# (0.4ms)  SELECT "users"."id", "users"."first_name" FROM "users" WHERE "users"."state" = 'pending'
# => [[3, "Mark"], [4, "Alice"]]
```

--

ids

```ruby
User.ids
# (0.5ms)  SELECT id FROM "users" WHERE "users"."state" = 'pending'
# => [3, 4]
```

```ruby
class User < ActiveRecord::Base
  self.primary_key = 'user_id'
end
```

```ruby
User.ids
# (0.2ms)  SELECT user_id FROM "users" WHERE "users"."state" = 'pending'
```

---

## Existence of Objects

`exists?`

```ruby
User.exists?(1)
# User Exists (0.2ms)  SELECT 1 AS one FROM "users" WHERE "users"."id" = 1 LIMIT 1
# => true

User.exists?(3)
# User Exists (0.4ms)  SELECT 1 AS one FROM "users" WHERE "users"."id" = 3 LIMIT 1
# => false
```

```ruby
User.where(first_name: 'Ryan').exists?
# User Exists (0.4ms)  SELECT 1 AS one FROM "users" WHERE "users"."first_name" = 'Ryan' LIMIT 1
# => false
```

```ruby
User.exists?
# User Exists (0.5ms)  SELECT 1 AS one FROM "users" LIMIT 1
# => true
```

--

`any?` and `many?` via a model

```ruby
Post.any?
# (0.1ms)  SELECT COUNT(*) FROM "posts"
# => true
```

```ruby
Post.many?
# (0.4ms)  SELECT COUNT(*) FROM "posts"
# => true
```

via a relation

```ruby
Post.where(published: true).any?
Post.where(published: true).many?
```

via an association

```ruby
Post.first.tags.any?
Post.first.tags.many?
```

---

## Calculations

count

```ruby
User.count
# (0.4ms)  SELECT COUNT(*) FROM "users"
# => 2
```

```ruby
User.where(first_name: 'Ryan').count
# (0.4ms)  SELECT COUNT(*) FROM "users" WHERE "users"."first_name" = 'Ryan'
# => 2
```

average

```ruby
PostInfo.average(:views)
# (0.5ms)  SELECT AVG("post_infos"."views") AS avg_id FROM "post_infos"
# => #<BigDecimal:537e948,'0.55E1',18(45)>
```

--

minimum

```ruby
PostInfo.minimum(:views)
# (0.4ms)  SELECT MIN("post_infos"."views") AS min_id FROM "post_infos"
# => 2
```

maximum

```ruby
PostInfo.maximum(:views)
# (0.5ms)  SELECT MAX("post_infos"."views") AS max_id FROM "post_infos"
# => 9
```

sum

```ruby
PostInfo.sum(:views)
# (0.4ms)  SELECT SUM("post_infos"."views") AS sum_id FROM "post_infos"
# => 11
```

---

## Running EXPLAIN

```ruby
User.where(id: 1).joins(:posts).explain
# User Load (6.0ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE "users"."id" = ?  [["id", 1]]
```

sqlite3

```stdout
=> EXPLAIN for: SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE "users"."id" = ? [["id", nil]]
0|0|0|SEARCH TABLE users USING INTEGER PRIMARY KEY (rowid=?)
0|1|1|SCAN TABLE posts
```

MySQL and MariaDB

```stdout
EXPLAIN for: SELECT `users`.* FROM `users` INNER JOIN `posts` ON `posts`.`user_id` = `users`.`id` WHERE `users`.`id` = 1
+----+-------------+----------+-------+---------------+
| id | select_type | table    | type  | possible_keys |
+----+-------------+----------+-------+---------------+
|  1 | SIMPLE      | users    | const | PRIMARY       |
|  1 | SIMPLE      | posts    | ALL   | NULL          |
+----+-------------+----------+-------+---------------+
+---------+---------+-------+------+-------------+
| key     | key_len | ref   | rows | Extra       |
+---------+---------+-------+------+-------------+
| PRIMARY | 4       | const |    1 |             |
| NULL    | NULL    | NULL  |    1 | Using where |
+---------+---------+-------+------+-------------+

2 rows in set (0.00 sec)
```

--

PostgreSQL

```stdout
EXPLAIN for: SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE "users"."id" = 1
                                  QUERY PLAN
------------------------------------------------------------------------------
 Nested Loop Left Join  (cost=0.00..37.24 rows=8 width=0)
   Join Filter: (posts.user_id = users.id)
   ->  Index Scan using users_pkey on users  (cost=0.00..8.27 rows=1 width=4)
         Index Cond: (id = 1)
   ->  Seq Scan on posts  (cost=0.00..28.88 rows=8 width=4)
         Filter: (posts.user_id = 1)
(6 rows)
```

---

# Testing Models

A model spec should include tests for the following:

* Validations
* Associations
* Callbacks
* Class and instance methods

---

## Tests configuration

Gemfile <!-- .element: class="filename" -->

```ruby
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'ffaker'
  gem 'database_cleaner'
end
```

```bash
$ bundle
$ rails g rspec:install
  create  .rspec
  create  spec
  create  spec/spec_helper.rb
```

config/application.rb <!-- .element: class="filename" -->

```ruby
config.generators do |g|
  g.test_framework :rspec
  g.fixture_replacement :factory_girl, dir: 'spec/factories'
end
```

---

## Basic structure

```bash
$ rails g model User email:text name:text admin:boolean
  invoke  active_record
  create    db/migrate/20160410131731_create_users.rb
  create    app/models/user.rb
  invoke    rspec
  create      spec/models/user_spec.rb
  invoke      factory_girl
  create        spec/factories/users.rb
```

app/models/user.rb <!-- .element: class="filename" -->

```ruby
class User < ApplicationRecord
  validates :email, :first_name, presence: true
  validates :email, uniqueness: true

  has_many :posts

  scope :admins, -> { where(admin: true) }

  after_update :email_changed, if: :email_changed?

  private

  def email_changed
    UserMailer.email_changed(self).deliver
  end
end
```

--

app/mailers/user_mailer.rb <!-- .element: class="filename" -->

```ruby
class UserMailer < ApplicationMailer
  def email_changed(user)
    # Sending email
  end
end
```

spec/models/user_spec.rb <!-- .element: class="filename" -->

```ruby
require 'spec_helper'

describe User do
  it 'is invalid without an email'
  it 'has unique email'
  it 'is invalid without a name'

  it 'has many posts'

  context '.admins' do
    it 'returns list of admins'
    it "doesn't return regular users"
  end

  context 'change email' do
    it 'sends email changed notification'
    it "doesn't send email changed notification" do
  end
end
```

---

## Database Cleaner

[DatabaseCleaner](https://github.com/bmabey/database_cleaner) is a set of strategies for cleaning your database in Ruby. The original use case was to ensure a
clean state during tests. Each strategy is a small amount of code but is code that is usually needed in any ruby app
that is testing with a database.

spec/spec_helper.rb <!-- .element: class="filename" -->

```ruby
# This part turns off the default RSpec database cleansing strategy.
config.use_transactional_fixtures = false

config.before(:suite) do
  # This says that before the entire test suite runs, clear the test database out completely.
  # This gets rid of any garbage left over from interrupted or poorly-written tests - a common source of surprising test behavior.
  DatabaseCleaner.clean_with(:truncation)

  # This part sets the default database cleaning strategy to be transactions.
  # Transactions are very fast, and for all the tests where they do work - that is, any test where the entire test runs in the RSpec process - they are preferable.
  DatabaseCleaner.strategy = :transaction
end

# These lines hook up database_cleaner around the beginning and end of each test,
# telling it to execute whatever cleanup strategy we selected beforehand.
config.before(:each) do
  DatabaseCleaner.start
end

config.after(:each) do
  DatabaseCleaner.clean
end
```

---

## FactoryGirl

[FactoryGirl](https://github.com/thoughtbot/factory_girl) is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

--

## Factory

spec/factories/users.rb <!-- .element: class="filename" -->

```ruby
FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    email { FactoryGirl.generate(:email) }
    name 'John Doe'
    admin false

    factory :admin do
      admin true
    end

    factory :author do
      ignore do
        posts_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end

  factory :post do
    title 'Post title'
    user
  end
end
```

--

```ruby
# Saved instance
user = FactoryGirl.create(:user)

# Unsaved instance
user = FactoryGirl.build(:user)

# Attribute hash (ignores associations)
user_attributes = FactoryGirl.attributes_for(:user)

# Stubbed object
user_stub = FactoryGirl.build_stubbed(:user)

# Override attributes
user = FactoryGirl.create(:user, name: 'Jack Daniel')

# Passing a block to any of the methods above will yield the return object
user = FactoryGirl.create(:user) do |user|
  user.posts.create(FactoryGirl.attributes_for(:post))
end
```

---

## FFaker (Faker refactored)

[FFaker](https://github.com/ffaker/ffaker) is used to easily generate fake data: names, addresses, phone numbers, etc.

spec/factories/users.rb <!-- .element: class="filename" -->

```ruby
FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    admin false

    factory :admin do
      admin true
    end

    factory :author do
      ignore do
        posts_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end

  factory :post do
    title { FFaker::Lorem.sentence }
    user
  end
end
```

---

## Testing validations

```ruby
describe User do
  let(:user) { FactoryGirl.create :user }

  it 'is invalid without an email' do
    expect(FactoryGirl.build :user, email: nil).not_to be_valid
  end

  it 'does not allow duplicate emails' do
    expect(FactoryGirl.build :user, email: user.email).not_to be_valid
  end

  it 'is invalid without a name' do
    expect(FactoryGirl.build :user, name: nil).not_to be_valid
  end
end
```

---

## Testing associations

```ruby
describe User do
  let(:user) { FactoryGirl.create :user }

  it 'has many posts' do
    expect(user).to respond_to :posts
  end
end
```

---

## Testing scopes

```ruby
describe User do
  context '.admins' do
    before do
      @users = FactoryGirl.create_list(:user, 3)
      @admins = FactoryGirl.create_list(:admin, 3)
    end

    it 'returns list of admins' do
      expect(User.admins).to match_array(@admins)
    end

    it "doesn't return regular users" do
      expect(User.admins).not_to match_array(@users)
    end
  end
end
```

---

## Testing callbacks

```ruby
describe User do
  let(:user) { FactoryGirl.create :user }

  context 'change email' do
    it 'sends email changed notification' do
      user.email = FFaker::Internet.email
      expect(UserMailer).to receive(:email_changed).with(user).and_return(double('meil', deliver: true))
      user.save
    end

    it "doesn't send email changed notification" do
      user.name = 'Santa Claus'
      expect(UserMailer).not_to receive(:email_changed)
      user.save
    end
  end
end
```

---

## Shoulda matchers

[Shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) provides RSpec- and Minitest-compatible one-liners that test common Rails functionality. These tests would otherwise be much longer, more complex, and error-prone.

```ruby
group :test do
  gem 'shoulda-matchers'
end
```

spec/models/user_spec.rb <!-- .element: class="filename" -->

```ruby
require 'spec_helper'

describe User do
  it { expect(user).to validate_presence_of(:email) }
  it { expect(user).to validate_uniqueness_of(:email) }
  it { expect(user).to validate_presence_of(:name) }
  it { expect(user).to have_many(:posts) }
end
```

---

## Homework. Amazon.

```text
Business logic structure:

Book
- Should contain title, descirption, price and how many books in stock
- Title, price, books in stock fields should be required
- Should belong to author and category
- Should have many ratings from costomers

Category
- Has a title
- Title should be required and unique
- Should have many books

Author
- Should contain firstname, lastname, biography
- Firstname, lastname fields should be required
- Should have many books

Rating
- Should contain text review and rating number from one to ten
- Should belong to customer and book

Customer
- Should contain email, password, firstname, lastname
- Email, password, firstname, lastname fields should be required
- Email should be unique
- Should have many orders, ratings
- A customer should be able to create a new order
- A customer should be able to return a current order in progress

Order
- Should contain total price, completed date and state (in progress/complited/shipped)
- Total price, completed date and state fields should be required
- By default an order should have 'in progress' state
- Should belong to customer and credit card
- Should have many order items
- Should have one billing address and one shipping address
- An order should be able to add a book to the order
- An order should be able to return a total price of the order

OrderItem
- Should contain price and quantity
- Price and quantity fields should be required
- Should belong to book and order

Address
- Should contain address, zipcode, city, phone, country
- All fields should be required

Country
- Should contain a name
- Name should be required and unique

CreditCard
- Should contain number, CVV, expiration month, expiration year, firstname, lastname
- All fields should be required
- Should belong to customer and have many orders

Necessary to create a DB structure, models, associations and validations to models, autotests and factories for autotests.
```

---

# The End

<br>

[Go to Table of Contents](/)
