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

# Reverse previous migration

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

# Methods for db structure changing

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

# Run run run ruuuuuuuuun

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

---

# ActiveRecord functions

Rails console

```bash
$ rails c
```

## new

```irb
user = User.new
# => #<User id: nil, first_name: nil, email: nil, password: nil, created_at: nil, updated_at: nil, last_name: nil, receive_news: false >]
```

## save

```irb
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

```irb
User.all
# SELECT "users".* FROM "users"
# => #<ActiveRecord::Relation [#<User id: 1, first_name: "Anna", email: "happy_ann@gmail.com", password: nil, created_at: "2016-04-10 19:00:01", updated_at: "2016-04-10 19:00:01", receive_news: nil, last_name: nil>]>
```

## Rails 3

```irb
User.all.class

# SELECT "users".* FROM "users"
# => Array
```

## Rails 4

```irb
User.all.class
# => ActiveRecord::Relation
```

---

# ActiveRecord functions

## create

```bash
new_user = User.create(first_name: 'Ivan', email: 'ivan.melechov@gmail.com')
# (0.1ms)  begin transaction
# SQL (1.5ms)  INSERT INTO "users" ("first_name", "email", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["first_name", "Ivan"], ["email", "ivan.melechov@gmail.com"], ["created_at", 2016-04-10 19:09:42 UTC], ["updated_at", 2016-04-10 19:09:42 UTC]]
# (0.8ms)  commit transaction
# => #<User id: 2, first_name: "Ivan", email: "ivan.melechov@gmail.com", password: nil, created_at: "2016-04-10 19:09:42", updated_at: "2016-04-10 19:09:42", receive_news: nil, last_name: nil>
```

--

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

---

# belongs_to

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
![](assets/has_many.png)

---

## has_many
app/models/user.rb
```ruby
class User
### Get
```bash
> user.posts
SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = 1
=> [#]
```
### Create
```bash
> user.posts  [#, #]
```
```bash
> user.posts.create(text: "New post")
INSERT INTO "posts" ("created_at", "text","updated_at", "user_id") VALUES (?, ?, ?, ?)  [["created_at", Sun, 10 Jun 2016 19:25:27 UTC +00:00], ["text", "New post"], ["updated_at", Sun, 10 Jun 2016 19:25:27 UTC +00:00], ["user_id", 1]]
=> #
```
### Count
```bash
> user.posts.count
SELECT COUNT(*) FROM "posts" WHERE "posts"."user_id" = 1
=> 2
```

---

## has_one
![](assets/has_one.png)

---

## has_one
```bash
bin/rails g model PostInfo post_id:integer views:integer likes:integer rating:integer
```
app/models/post_info.rb
```ruby
class PostInfo
app/models/post.rb
```ruby
class Post
```bash
> post = Post.first
SELECT "posts".* FROM "posts" LIMIT 1
=> #
```
### Creation PostInfo
```bash
> PostInfo.create(post_id: post.id, views: 40, likes: 5, rating: 10)
INSERT INTO "post_infos" ("created_at", "likes", "post_id", "rating", "updated_at", "views") VALUES (?, ?, ?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["likes", 5], ["post_id", 1], ["rating", 10], ["updated_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["views", 40]]
=> #
```
### Getting using the association
```bash
> post.post_info
SELECT "post_infos".* FROM "post_infos" WHERE "post_infos"."post_id" = 1 LIMIT 1
=> #
```
### Creation using the association
```bash
> post.create_post_info(views: 40, likes: 5, rating: 10)
INSERT INTO "post_infos" ("created_at", "likes", "post_id", "rating", "updated_at", "views") VALUES (?, ?, ?, ?, ?, ?)  [["created_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["likes", 5], ["post_id", 1], ["rating", 10], ["updated_at", Sun, 10 Apr 2016 19:50:10 UTC +00:00], ["views", 40]]
=> #
```

---

## has_many :through
![](assets/has_many_through.png)

---

## has_many :through
```bash
bin/rails g model Blog title:string description:text
invoke  active_record
create    db/migrate/20160410194224_create_blogs.rb
create    app/models/blog.rb
invoke    test_unit
create      test/models/blog_test.rb
create      test/fixtures/blogs.yml
```
```bash
bin/rails g model Subscription user:belongs_to blog:belongs_to receive_news:boolean
invoke  active_record
create    db/migrate/20160410194832_create_subscriptions.rb
create    app/models/subscription.rb
invoke    test_unit
create      test/models/subscription_test.rb
create      test/fixtures/subscriptions.yml
```
```bash
bin/rails g migration AddBlogRefToPosts blog:references
invoke  active_record
create    db/migrate/20160410195621_add_blog_ref_to_posts.rb
```
db/migrate/20160410194224_create_blogs.rb
```ruby
class CreateBlogs
db/migrate/20160410194832_create_subscriptions.rb
```ruby
class CreateSubscriptions
db/migrate/20160410195621_add_blog_ref_to_posts.rb
```ruby
class AddBlogRefToPosts
app/models/user.rb
```ruby
class User
app/models/blog.rb
```ruby
class Blog
app/models/subscription.rb
```ruby
class Subscription
app/models/post.rb
```ruby
class Post

---

## has_one :through
![](assets/has_one_through.png)

---

## has_one :through
```bash
bin/rails g model Plan name:string description:text price:decimal{8.2}
invoke  active_record
create    db/migrate/20160410202622_create_plans.rb
create    app/models/plan.rb
invoke    test_unit
create      test/models/plan_test.rb
create      test/fixtures/plans.yml
```
```bash
bin/rails g model UserPlan user:belongs_to plan:belongs_to
invoke  active_record
create    db/migrate/20160410203824_create_user_plans.rb
create    app/models/user_plan.rb
invoke    test_unit
create      test/models/user_plan_test.rb
create      test/fixtures/user_plans.yml
```
db/migrate/20160410202622_create_plans.rb
```ruby
class CreatePlans
db/migrate/20160410203824_create_user_plans.rb
```ruby
class CreateUserPlans
app/models/user.rb
```ruby
class User
app/models/user_plan.rb
```ruby
class UserPlan
app/models/plan.rb
```ruby
class Plan

---

## has_and_belongs_to_many
![](assets/has_and_belongs_to_many.png)

---

## has_and_belongs_to_many
```bash
bin/rails g model Tag name:string
invoke  active_record
create    db/migrate/20160414211322_create_tags.rb
create    app/models/tag.rb
invoke    test_unit
create      test/models/tag_test.rb
create      test/fixtures/tags.yml
```
```bash
bin/rails g migration create_posts_tags post:references tag:references --no-timestamp
invoke  active_record
create    db/migrate/20160414213342_create_posts_tags.rb
```
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
db/migrate/20160414213342_create_posts_tags.rb
```ruby
class CreatePostsTags
#### Change migration. Add common index and remove id.
db/migrate/20160414213342_create_posts_tags.rb
```ruby
class CreatePostsTags
app/models/post.rb
```ruby
class Post
app/models/tag.rb
```ruby
class Tag

---

## Polymorphic Associations
![](assets/polymorphic.png)

---

## Polymorphic Assosiations
```bash
bin/rails g model Picture imageable:references{polymorphic} file:string
invoke  active_record
create    db/migrate/20160414231322_create_pictures.rb
create    app/models/picture.rb
invoke    test_unit
create      test/models/picture_test.rb
create      test/fixtures/pictures.yml
```
db/migrate/20160414231322_create_pictures.rb
```ruby
class CreatePictures
app/models/picture.rb
```ruby
class Picture
app/models/user.rb
```ruby
class User
app/models/post.rb
```ruby
class Post
```bash
> user.create_picture(file: 'public/picture/photo.png')
INSERT INTO "pictures" ("created_at", "file", "imageable_id", "imageable_type", "updated_at") VALUES (?, ?, ?, ?, ?)  [["created_at", Fri, 15 Apr 2016 17:35:01 UTC +00:00], ["file", "public/picture/photo.png"], ["imageable_id", 1], ["imageable_type", "User"], ["updated_at", Fri, 15 Apr 2016 17:35:01 UTC +00:00]]
=> #
```
```bash
> post.pictures.create(file: 'public/picture/image.png')
INSERT INTO "pictures" ("created_at", "file", "imageable_id", "imageable_type", "updated_at") VALUES (?, ?, ?, ?, ?)  [["created_at", Fri, 15 Apr 2016 17:45:21 UTC +00:00], ["file", "public/picture/image.png"], ["imageable_id", 1], ["imageable_type", "Post"], ["updated_at", Fri, 15 Apr 2016 17:45:21 UTC +00:00]]
=> #
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
`save(validate: false)`

---

## valid? and invalid?
```ruby
class User
### valid?
```ruby
> User.new(email: "thebestemail@ua.fm").valid?
=> true
> User.new().valid?
=> false
```
### Get errors
```ruby
> u = User.new
=> #
&gt; u.errors
=&gt; #, @messages={}&gt;
&gt; u.valid?
=&gt; false
&gt; u.errors
=&gt; #, @messages={:email=&gt;["can't be blank"]}&gt;
```
### On create
```ruby
> u = User.create
=> #
&gt; u.errors
=&gt; #, @messages={:email=&gt;["can't be blank"]}&gt;
```
### On create!
```ruby
> User.create!
ActiveRecord::RecordInvalid: Validation failed: Email cant be blank
```
### On save and save!
```ruby
> u = User.new
=> #
&gt; u.save
=&gt; false
&gt; u.save!
ActiveRecord::RecordInvalid: Validation failed: Email cant be blank
```

---

## errors\[\]
```ruby
> User.new.errors[:email].any?
=> false
> User.create.errors[:email].any?
=> true
> User.create.errors.messages
=> {email:["can't be blank"]}
> User.create.errors.details[:email]
=>  [{error: :blank}]
> User.create.errors.full_messages
=> ["Email can't be blank"]
```

---

## Presence
```ruby
class User
```ruby
class Post
```ruby
class User
Can be used for the presence of an object associated validation via a has_one or has_many relationship, it will check
that the object is neither `blank?` nor `marked_for_destruction?`.
```ruby
validates :field_name, inclusion: { in:  [true, false] }. # for fields with boolean type
```

---

## Presence
```ruby
class User
```ruby
class Post

---

## Acceptance
```bash
bin/rails g migration AddTermsOfServiceToUsers terms_of_service:boolean
```
```ruby
class User
```ruby
class User
Do not this validation on the both sides of the association it causes endless cycle.

---

## Confirmation
```ruby
class User

---

## Inclusion
```ruby
class Tag

---

## Exclusion
```ruby
class User

---

## Format
```ruby
class User

---

## Length
```bash
bin/rails g migration AddCardNumberToUsers card_number:string
```
```ruby
class User
* `:minimum` – The attribute cannot have less than the specified length.
* `:maximum` – The attribute cannot have more than the specified length.
* `:in` (or `:within`) – The attribute length must be included in a given interval. The value for this option must be a
range.
* `:is` – The attribute length must be equal to the given value.

---

## Numericality
```ruby
class PostInfo
* `:greater_than`
* `:greater_than_or_equal_to`
* `:equal_to`
* `:less_than`
* `:less_than_or_equal_to`
* `:odd`
* `:even`
By default, numericality doesn't allow nil values. You can use `allow_nil: true` option to permit it.

---

## Uniqueness
```bash
bin/rails g AddPageAddressToUsers page_address:string
```
```ruby
class User

---

## Validates Assosiated
```ruby
class User

---

## validates_with
```ruby
class User
```ruby
class User

---

## validate_each
```ruby
class User

---

## General options
```ruby
class Post
```ruby
class User
```ruby
class User  }
message: -&gt;(object, data) do
"Hey #{object.name}!, #{data[:value]} is taken already! Try again #{Time.zone.tomorrow}"
end
}
end
```
\:allow_nil and :allow_blank are ignored by :presence
```ruby
class User

---

## Strict validations
```ruby
class User  ActiveModel::StrictValidationFailed: "Email can't be blank"
```

---

## Condional validations
```ruby
class User
```ruby
validates :last_name, presence: true, if: "first_name.nil?"
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
class User

---

## Custom Validators
```ruby
class MyValidator
```ruby
class EmailValidator

---

## Custom Methods
```bash
bin/rails g model Payment discount:decimal{8.2} total_value:decimal{8.2} expiration_date:date
```
```ruby
class Payment  total_value
errors.add(:discount, "can't be greater than total value")
end
end
end
```

---

## Validation Errors
### errors.add
```ruby
class User
```ruby
user = User.create(:first_name => "!@#")
user.errors[:first_name] # => ["cannot contain the characters !@#%*()_-+="]
user.errors.full_messages  # => ["Name cannot contain the characters !@#%*()_-+="]
```
```ruby
class User
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
bin/rails g migration AddLoginToUsers login:string
```
```ruby
class User

---

## Availiable Callbacks
### Creating an Object
1.  `before_validation`
2.  `after_validation`
3.  `before_save`
4.  `around_save`
5.  `before_create`
6.  `around_create`
7.  `after_create`
8.  `after_save`
9.  `after_commit/after_rollback`
### Updating an Object
1.  `before_validation`
2.  `after_validation`
3.  `before_save`
4.  `around_save`
5.  `before_update`
6.  `around_update`
7.  `after_update`
8.  `after_save`
9.  `after_commit/after_rollback`
### Destroying an Object
1.  `before_destroy`
2.  `around_destroy`
3.  `after_destroy`
4.  `after_commit/after_rollback`

---

## After_find and after_initialize
```ruby
class User > User.new
You have initialized an object!
=> #
&gt;&gt; User.first
You have found an object!
You have initialized an object!
=&gt; #
```
## After_touch
```ruby
class User > u = User.create(name: 'Martin')
=> #
&gt;&gt; u.touch
You have touched an object
=&gt; true
```
```ruby
class Post > @post = Post.last
=> #
# triggers @post.user.touch
&gt;&gt; @post.touch
User was touched
An Post was touched
=&gt; true
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
class User
```bash
> user = User.first
=> #
&gt; user.posts.create!
=&gt; #
&gt; user.destroy
# Post destroyed
=&gt; #
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
class PictureFile
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
class PictureFile

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
class PictureFile
* `after_create_commit`
* `after_update_commit`
* `after_destroy_commit`

---

# Query Interface

---

## Retrieving Objects from the Database
```ruby
find
create_with
distinct
eager_load
extending
from
group
having
includes
joins
left_outer_joins
limit
lock
none
offset
order
preload
readonly
references
reorder
reverse_order
select
where
```
```ruby
ActiveRecord::Relation
```

---

## Retrieving a Single Object
Using a Primary Key
```bash
> User.find(1)
User Load (0.4ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
=> #
```
take
```bash
> User.take
User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 1
=> #
```
first
```bash
> User.first
User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
=> #
```
last
```bash
> User.last
User Load (0.5ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
=> #
```
take, first, last, find_by returns nil if no matching record is found and no exception will be raised. take!, first!, last!, find_by! raise ActiveRecord::RecordNotFound if no matching record is found. find_by
```bash
> User.find_by first_name: "Anna"
User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."first_name" = 'Anna' LIMIT 1
=> #
```
```bash
> User.find_by first_name: "Anna", email: "some@ua.fm"
User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."first_name" = 'Anna' AND "users"."email" = 'some@ua.fm' LIMIT 1
=> nil
```

---

## Retrieving Multiple Objects
Using Multiple Primary Keys
```bash
> User.find([1, 2]) # User.find(1, 2)
User Load (0.7ms)  SELECT "users".* FROM "users" WHERE "users"."id" IN (1, 2)
=> [#, #]
```
take
```bash
> User.take(2)
User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 2
=> [#, #]
```
first
```bash
> User.first(2)
User Load (0.5ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 2
=> [#, #]
```
last
```bash
> User.last(2)
User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 2
=> [#, #]
```

---

## Retrieving Multiple Objects in Batches
```bash
> User.all.each do |user|
puts user.first_name
end
User Load (0.5ms)  SELECT "users".* FROM "users"
Anna
Vanka
=> [#, #]
```
find_each
```bash
> User.find_each do |user|
puts user.first_name
end
User Load (0.7ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1000
Anna
Vanka
=> nil
```
\:batch_size
```bash
> User.find_each(batch_size: 1) do |user|
puts user.first_name
end
User Load (0.3ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
Anna
User Load (0.2ms)  SELECT "users".* FROM "users" WHERE ("users"."id" > 1) ORDER BY "users"."id" ASC LIMIT 1
Vanka
User Load (0.1ms)  SELECT "users".* FROM "users" WHERE ("users"."id" > 2) ORDER BY "users"."id" ASC LIMIT 1
=> nil
```
\:start
```bash
> User.find_each(start: 2, batch_size: 1) do |user|
puts user.first_name
end
User Load (0.7ms)  SELECT "users".* FROM "users" WHERE ("users"."id" >= 2) ORDER BY "users"."id" ASC LIMIT 1
Vanka
User Load (0.6ms)  SELECT "users".* FROM "users" WHERE ("users"."id" > 2) ORDER BY "users"."id" ASC LIMIT 1
=> nil
```
find_in_batches
```bash
> Post.find_in_batches(include: :tags) do |posts|
puts posts.map(&:tags)
end
Post Load (0.5ms)  SELECT "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT 1000
SQL (0.5ms)  SELECT "tags".*, "t0"."post_id" AS ar_association_key_name FROM "tags" INNER JOIN "posts_tags" "t0" ON "tags"."id" = "t0"."tag_id" WHERE "t0"."post_id" IN (1, 2)
#
```

---

## Conditions
String conditions
```bash
> User.where("first_name = 'Anna'")
User Load (0.4ms)  SELECT "users".* FROM "users" WHERE (first_name = 'Anna')
=> #]&gt;
```
Array conditions
```ruby
User.where("email = ?", params[:email])
```
```ruby
User.where("last_name = ? AND receive_news = ?", params[:last_name], true)
```
Placeholder conditions
```bash
> Payment.where("created_at >= :start_date", { start_date: 10.days.ago })
Payment Load (0.1ms)  SELECT "payments".* FROM "payments" WHERE (created_at >= '2013-06-13 18:56:01.086812')
=> #
```
Hash conditions
```ruby
User.where(first_name: 'Anna')
```
```ruby
User.where('first_name' => 'Anna')
```
```ruby
> Post.where(user: User.first)
SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = 1
=> #
```
Range conditions
```bash
> User.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
User Load (0.5ms)  SELECT "users".* FROM "users" WHERE ("users"."created_at" BETWEEN '2013-06-21 21:00:00.000000' AND '2013-06-22 21:00:00.000000')
=> #
```
Subset conditions
```bash
> Tag.where(name: ['cooking', 'programming'])
SELECT "tags".* FROM "tags" WHERE "tags"."name" IN ('cooking', 'programming')
=> #
```
NOT conditions
```bash
> Post.where.not(user: User.first)
User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
Post Load (0.2ms)  SELECT "posts".* FROM "posts" WHERE ("posts"."user_id" != 1)
=> #
```

---

## Ordering
```bash
> User.order("created_at")
SELECT "users".* FROM "users" ORDER BY created_at
=> #, #]&gt;
```
ASC, DESC
```ruby
User.order("created_at ASC")
```
```ruby
User.order("created_at DESC")
```
ordering by multiple fields
```ruby
User.order("id ASC,created_at DESC")
```
```ruby
User.order("id ASC").order("created_at DESC")
```

---

## Selecting
```bash
User.select("first_name, email")
User Load (0.4ms)  SELECT first_name, email FROM "users"
=> #, #]&gt;
```
```bash
User.select("status")
User Load (0.6ms)  SELECT status FROM "users"
SQLite3::SQLException: no such column: status: SELECT status FROM "users"
ActiveRecord::StatementInvalid: SQLite3::SQLException: no such column: status: SELECT status FROM "users"
```
distinct
```bash
> User.select(:first_name).distinct
User Load (0.5ms)  SELECT DISTINCT first_name FROM "users"
=> #, #]&gt;
```
```ruby
query = User.select(:name).distinct
query.distinct(false)
```

---

## Limit and Offset
limit
```bash
> User.limit(5)
User Load (0.6ms)  SELECT "users".* FROM "users" LIMIT 5
=> #, #]&gt;
```
offset
```bash
> User.limit(5).offset(1)
User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 5 OFFSET 1
=> #]&gt;
```

---

## Group
```bash
> p = PostInfo.select("id, sum(views) AS sum_views").group("post_id")
PostInfo Load (0.5ms)  SELECT id, sum(views) AS sum_views FROM "post_infos" GROUP BY post_id
=> #, #]&gt;
&gt; p.each{ |p| puts p.sum_views }
9
2
=&gt; [#, #]
```

---

## Having
```bash
> p = PostInfo.select("id, sum(views) AS sum_views").group("post_id").having("sum(views) > 5")
PostInfo Load (0.5ms)  SELECT id, sum(views) AS sum_views FROM "post_infos" GROUP BY post_id HAVING sum(views) > 5
=> #]&gt;
&gt; p.each{ |p| puts p.sum_views }
9
=&gt; [#]
```

---

## Overriding Conditions
except
```bash
> Post.where('id > 2').limit(2).except(:limit)
Post Load (0.5ms)  SELECT "posts".* FROM "posts" WHERE (id > 2)
=> #, #]&gt;
```
unscope
```ruby
Post.order('id DESC').limit(20).unscope(:order) # == Post.limit(20)
Post.order('id DESC').limit(20).unscope(:order, :limit) # == Post.all
```
only
```bash
> Post.where('id > 2').limit(2).order('id desc')
Post Load (0.5ms)  SELECT "posts".* FROM "posts" WHERE (id > 2) ORDER BY id desc LIMIT 2
=> #, #]&gt;
```
```bash
> Post.where('id > 2').limit(2).order('id desc').only(:order, :where)
Post Load (0.5ms)  SELECT "posts".* FROM "posts" WHERE (id > 2) ORDER BY id desc
=> #, #, #]&gt;
```
reorder
```ruby
class User  { order('created_at DESC') }
end
```
```bash
> User.find(2).posts.reorder('title')
User Load (0.3ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 2]]
Post Load (0.6ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ? ORDER BY title  [["user_id", 2]]
=> #, #]
```
reverse_order
```bash
> User.order(:created_at)
User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users".created_at ASC
=> #, #]&gt;
```
```bash
> User.order(:created_at).reverse_order
User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users".created_at DESC
=> #, #]&gt;
```
rewhere
```bash
> User.where(admin: true).rewhere(admin: false)
SELECT * FROM users WHERE `admin` = 0
```
```bash
> User.where(admin: true).where(admin: false)
SELECT * FROM users WHERE `admin` = 1 AND `admin` = 0
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
user  = User.readonly.first
user.first_name = "Anny"
user.save
ActiveRecord::ReadOnlyRecord: ActiveRecord::ReadOnlyRecord
```

---

## Locking Records for Update
### Optimistic locking
Optimistic locking allows multiple users to access the same record for edits, and assumes a minimum of conflicts with
the data. It does this by checking whether another process has made changes to a record since it was opened, an
ActiveRecord::StaleObjectError exception is thrown if that has occurred and the update is ignored.
`lock_version` field should present. Each update to the record increments the lock_version column and the locking
facilities ensure that records instantiated twice will let the last one saved raise a StaleObjectError if the first was
also updated.
```ruby
u1 = User.find(1)
u2 = User.find(1)
u1.first_name = "Michael"
u1.save
u2.first_name = "should fail"
u2.save # Raises an ActiveRecord::StaleObjectError
```

---

## Locking Records for Update
### Pessimistic locking
It provides support for row-level locking using SELECT … FOR UPDATE and other lock types.
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
```bash
> users = User.joins('LEFT OUTER JOIN posts ON posts.user_id = users.id')
User Load (0.3ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN posts ON posts.user_id = users.id
=> #, #, #, #, #]&gt;
&gt; users.length
User Load (0.7ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN posts ON posts.user_id = users.id
=&gt; 5
&gt; Post.all.length
Post Load (0.5ms)  SELECT "posts".* FROM "posts"
=&gt; 5
```
left_outer_joins
```bash
> User.left_outer_joins(:posts).distinct
User Load (1.4ms)  SELECT DISTINCT "users".* FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"
=> #, #, #, #, #]&gt;
```
Joining a Single Association
```bash
> User.joins(:posts)
User Load (0.5ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id"
```
Joining Multiple Associations
```bash
> Post.joins(:tags, :blog)
Post Load (0.6ms)  SELECT "posts".* FROM "posts" INNER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" INNER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" INNER JOIN "blogs" ON "blogs"."id" = "posts"."blog_id"
=> #]&gt;
```
Joining Nested Associations (Single Level)
```bash
> Post.joins(blog: :users)
Post Load (0.2ms)  SELECT "posts".* FROM "posts" INNER JOIN "blogs" ON "blogs"."id" = "posts"."blog_id" INNER JOIN "subscriptions" ON "subscriptions"."blog_id" = "blogs"."id" INNER JOIN "users" ON "users"."id" = "subscriptions"."user_id"
```
Joining Nested Associations (Multiple Level)
```bash
> User.joins(posts: [{blog: :subscriptions}, :tags])
User Load (0.8ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" INNER JOIN "blogs" ON "blogs"."id" = "posts"."blog_id" INNER JOIN "subscriptions" ON "subscriptions"."blog_id" = "blogs"."id" INNER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" INNER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" WHERE "users"."state" = 'pending'
```
Specifying Conditions on the Joined Tables
```bash
> User.joins(:posts).where('posts.created_at' => (Time.now.midnight - 1.day)..Time.now.midnight)
User Load (0.5ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE ("posts"."created_at" BETWEEN '2013-06-22 21:00:00.000000' AND '2013-06-23 21:00:00.000000')
=> #, #]&gt;
```

---

## Eager Loading Associations
```bash
users = User.limit(10)
users.each do |user|
puts user.posts.map(&:title)
end
User Load (0.6ms)  SELECT "users".* FROM "users" LIMIT 10
=> #, #]&gt;
Post Load (0.6ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ?  [["user_id", 1]]
=&gt;
Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ?  [["user_id", 2]]
=&gt; First step
First step
```
```bash
users = User.includes(:posts).limit(10)
users.each do |user|
puts user.posts.map(&:title)
end
User Load (0.6ms)  SELECT "users".* FROM "users" LIMIT 10
Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (1, 2)
=> #, #]&gt;
=&gt;
=&gt;  First step
First step
=&gt; [#, #]
```
Array of Multiple Associations
```bash
>p =  Post.includes(:blog, :tags)
Post Load (0.5ms)  SELECT "posts".* FROM "posts"
Blog Load (0.3ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."id" IN (1)
SQL (0.3ms)  SELECT "tags".*, "t0"."post_id" AS ar_association_key_name FROM "tags" INNER JOIN "posts_tags" "t0" ON "tags"."id" = "t0"."tag_id" WHERE "t0"."post_id" IN (1, 2, 3, 4, 5)
=> #, #, #, #, #]&gt;
```
```bash
> p.first.tags
=> #
```
Nested Associations Hash
```bash
> User.includes([:subscriptions, {:posts => [:tags]}]).find(1)
User Load (1.9ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
Subscription Load (0.1ms)  SELECT "subscriptions".* FROM "subscriptions" WHERE "subscriptions"."user_id" IN (1)
Post Load (0.2ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (1)
SQL (0.2ms)  SELECT "tags".*, "t0"."post_id" AS ar_association_key_name FROM "tags" INNER JOIN "posts_tags" "t0" ON "tags"."id" = "t0"."tag_id" WHERE "t0"."post_id" IN (1, 2, 3)
=> #
```
Specifying Conditions on Eager Loaded Associations
```bash
> p = Post.includes(:tags).where("tags.name != 'nil'")
SQL (0.7ms)  SELECT "posts"."id" AS t0_r0, "posts"."text" AS t0_r1, "posts"."user_id" AS t0_r2, "posts"."created_at" AS t0_r3, "posts"."updated_at" AS t0_r4, "posts"."title" AS t0_r5, "posts"."published" AS t0_r6, "posts"."blog_id" AS t0_r7, "tags"."id" AS t1_r0, "tags"."name" AS t1_r1, "tags"."created_at" AS t1_r2, "tags"."updated_at" AS t1_r3 FROM "posts" LEFT OUTER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" LEFT OUTER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" WHERE (tags.name != 'nil')
=> #]&gt;
&gt; p.first.tags
=&gt; #]&gt;
```
```bash
> p = Post.includes(:tags).where("tags.name != 'nil'").references(:tags)
SQL (0.7ms)  SELECT "posts"."id" AS t0_r0, "posts"."text" AS t0_r1, "posts"."user_id" AS t0_r2, "posts"."created_at" AS t0_r3, "posts"."updated_at" AS t0_r4, "posts"."title" AS t0_r5, "posts"."published" AS t0_r6, "posts"."blog_id" AS t0_r7, "tags"."id" AS t1_r0, "tags"."name" AS t1_r1, "tags"."created_at" AS t1_r2, "tags"."updated_at" AS t1_r3 FROM "posts" LEFT OUTER JOIN "posts_tags" ON "posts_tags"."post_id" = "posts"."id" LEFT OUTER JOIN "tags" ON "tags"."id" = "posts_tags"."tag_id" WHERE (tags.name != 'nil')
```

---

## Scopes
```ruby
class Post  { where(published: true) }
end
```
```ruby
class Post
```ruby
class Post  { where(published: true) }
scope :published_with_tags, -> { published.where("tags_count > 0") }
end
```
```ruby
Post.published
```
```ruby
Tags.first.posts.published
```
Passing in arguments
```ruby
class Post (time) { where("created_at
```ruby
Post.created_before(Time.now)
```
Merging of scopes
```bash
bin/rails g migration AddStateToUser state:string
```
```ruby
class User  { where state: 'active' }
scope :inactive, -> { where state: 'inactive' }
end
```
```bash
> User.active.inactive
User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'active' AND "users"."state" = 'inactive'
```
```bash
> User.active.where(state: 'finished')
User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'active' AND "users"."state" = 'finished'
```
If we do want the last where clause to win
```bash
> User.active.merge(User.inactive)
User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'inactive'
```
default_scope - will be applied across all queries - will be overridden by scope and where conditions
```ruby
class User  { where state: 'active' }
scope :inactive, -> { where state: 'inactive' }
end
```
```bash
> User.all
User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending'
```
```bash
> User.active
User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'active'
```
```bash
> User.where(state: 'inactive')
User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'inactive'
```
Removing All Scoping
```bash
> User.unscoped.all
SELECT "users".* FROM "users"
```

---

## Dynamic finders
`first_name -> find_by_first_name or find_by_first_name! `

---

## Find or Build a New Object
find_or_create_by
```bash
> User.find_or_create_by(first_name: 'Mark')
User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending' AND "users"."first_name" = 'Mark' LIMIT 1
(0.3ms)  begin transaction
SQL (3.8ms)  INSERT INTO "users" ("created_at", "first_name", "state", "updated_at") VALUES (?, ?, ?, ?)  [["created_at", Mon, 24 Jun 2013 09:26:43 UTC +00:00], ["first_name", "Mark"], ["state", "pending"], ["updated_at", Mon, 24 Jun 2013 09:26:43 UTC +00:00]]
(134.1ms)  commit transaction
=> #
&gt; User.find_or_create_by(first_name: 'Mark')
User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending' AND "users"."first_name" = 'Mark' LIMIT 1
=&gt; #
```
```bash
User.find_or_create_by(first_name: 'Andy') do |c|
c.locked = false
end
```
find_or_initialize_by
```bash
> clark = User.find_or_initialize_by(first_name: 'Clark')
User Load (0.5ms)  SELECT "users".* FROM "users" WHERE "users"."state" = 'pending' AND "users"."first_name" = 'Clark' LIMIT 1
=> #
&gt; clark.persisted?
=&gt; false
&gt; clark.new_record?
=&gt; true
&gt; clark.save
```

---

## Finding by SQL
find_by_sql
```bash
>   User.find_by_sql("SELECT * FROM users INNER JOIN posts ON users.id = posts.user_id")
User Load (0.7ms)  SELECT * FROM users INNER JOIN posts ON users.id = posts.user_id
=> [#, #]
```
select_all
```bash
> Post.connection.select_all("SELECT * FROM posts WHERE id = '1'")
(0.5ms)  SELECT * FROM posts WHERE id = '1'
=> #
```
pluck
```bash
> User.where(state: "active").pluck(:id)
(0.5ms)  SELECT "users"."id" FROM "users" WHERE "users"."state" = 'active'
=> [1]
```
```bash
> User.distinct.pluck(:first_name)
(0.5ms)  SELECT DISTINCT "users"."first_name" FROM "users" WHERE "users"."state" = 'pending'
=> ["Mark", "Alice"]
```
```bash
> User.pluck(:id, :first_name)
(0.4ms)  SELECT "users"."id", "users"."first_name" FROM "users" WHERE "users"."state" = 'pending'
=> [[3, "Mark"], [4, "Alice"]]
```
ids
```bash
> User.ids
(0.5ms)  SELECT id FROM "users" WHERE "users"."state" = 'pending'
=> [3, 4]
```
```ruby
class User
```bash
> User.ids
(0.2ms)  SELECT user_id FROM "users" WHERE "users"."state" = 'pending'
```

---

## Existence of Objects
exists?
```bash
> User.exists?(1)
User Exists (0.2ms)  SELECT 1 AS one FROM "users" WHERE "users"."id" = 1 LIMIT 1
=> true
> User.exists?(3)
User Exists (0.4ms)  SELECT 1 AS one FROM "users" WHERE "users"."id" = 3 LIMIT 1
=> false
```
```bash
> User.where(first_name: 'Ryan').exists?
User Exists (0.4ms)  SELECT 1 AS one FROM "users" WHERE "users"."first_name" = 'Ryan' LIMIT 1
=> false
```
```bash
> User.exists?
User Exists (0.5ms)  SELECT 1 AS one FROM "users" LIMIT 1
=> true
```
any? and many? via a model
```bash
> Post.any?
(0.1ms)  SELECT COUNT(*) FROM "posts"
=> true
```
```bash
> Post.many?
(0.4ms)  SELECT COUNT(*) FROM "posts"
=> true
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
```bash
> User.count
(0.4ms)  SELECT COUNT(*) FROM "users"
=> 2
```
```bash
> User.where(:first_name => 'Ryan').count
(0.4ms)  SELECT COUNT(*) FROM "users" WHERE "users"."first_name" = 'Ryan'
=> 2
```
average
```bash
> PostInfo.average(:views)
(0.5ms)  SELECT AVG("post_infos"."views") AS avg_id FROM "post_infos"
=> #
```
minimum
```bash
> PostInfo.minimum(:views)
(0.4ms)  SELECT MIN("post_infos"."views") AS min_id FROM "post_infos"
=> 2
```
maximum
```bash
> PostInfo.maximum(:views)
(0.5ms)  SELECT MAX("post_infos"."views") AS max_id FROM "post_infos"
=> 9
```
sum
```bash
> PostInfo.sum(:views)
(0.4ms)  SELECT SUM("post_infos"."views") AS sum_id FROM "post_infos"
=> 11
```

---

## Running EXPLAIN
```bash
> User.where(id: 1).joins(:posts).explain
User Load (6.0ms)  SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE "users"."id" = ?  [["id", 1]]
```
sqlite3
```bash
=> EXPLAIN for: SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE "users"."id" = ? [["id", nil]]
0|0|0|SEARCH TABLE users USING INTEGER PRIMARY KEY (rowid=?)
0|1|1|SCAN TABLE posts
```
MySQL and MariaDB
```bash
EXPLAIN for: SELECT `users`.* FROM `users` INNER JOIN `posts` ON `posts`.`user_id` = `users`.`id` WHERE `users`.`id` = 1
+
---
-+

---


---
+

---

+
---

---
-+

---


---
--+
| id | select_type | table    | type  | possible_keys |
+
---
-+

---


---
+

---

+
---

---
-+

---


---
--+
|  1 | SIMPLE      | users    | const | PRIMARY       |
|  1 | SIMPLE      | posts    | ALL   | NULL          |
+
---
-+

---


---
+

---

+
---

---
-+

---


---
--+
+
---

---

---
+
---

---

---
+
---

---
-+
---

---
+

---


---
+
| key     | key_len | ref   | rows | Extra       |
+
---

---

---
+
---

---

---
+
---

---
-+
---

---
+

---


---
+
| PRIMARY | 4       | const |    1 |             |
| NULL    | NULL    | NULL  |    1 | Using where |
+
---

---

---
+
---

---

---
+
---

---
-+
---

---
+

---


---
+
2 rows in set (0.00 sec)
```
PostgreSQL
```bash
EXPLAIN for: SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" WHERE "users"."id" = 1
QUERY PLAN

---


---


---


---


---


---


---


---

---
--
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
Gemfile
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
bundle
```
```bash
rails g rspec:install
create  .rspec
create  spec
create  spec/spec_helper.rb
```
config/application.rb
```ruby
config.generators do |g|
g.test_framework :rspec
g.fixture_replacement :factory_girl, dir: 'spec/factories'
end
```

---

## Basic structure
```bash
rails g model User email:text name:text admin:boolena
invoke  active_record
create    db/migrate/20160410131731_create_users.rb
create    app/models/user.rb
invoke    rspec
create      spec/models/user_spec.rb
invoke      factory_girl
create        spec/factories/users.rb
```
app/models/user.rb
```ruby
class User  { where(admin: true) }
after_update :email_changed, if: :email_changed?
private
def email_changed
UserMailer.email_changed(self).deliver
end
end
```
app/mailers/user_mailer.rb
```ruby
class UserMailer
spec/models/user_spec.rb
```ruby
require 'spec_helper'
describe User do
it "is invalid without an email"
it "has unique email"
it "is invalid without a name"
it "has many posts"
context ".admins" do
it "returns list of admins"
it "doesn't return regular users"
end
context "change email" do
it "sends email changed notification"
it "doesn't send email changed notification" do
end
end
```

---

## Database Cleaner
[DatabaseCleaner][4] is a set of strategies for cleaning your database in Ruby. The original use case was to ensure a
clean state during tests. Each strategy is a small amount of code but is code that is usually needed in any ruby app
that is testing with a database.
spec/spec_helper.rb
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
[FactoryGirl][5] is a library for setting up Ruby objects as test data.
```ruby
FactoryGirl.define do
sequence :email do |n|
"email#{n}@factory.com"
end
factory :user do
email { FactoryGirl.generate(:email) }
name "John Doe"
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
title "Post title"
user
end
end
```
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
user = FactoryGirl.create(:user, name: "Jack Daniel")
# Passing a block to any of the methods above will yield the return object
user = FactoryGirl.create(:user) do |user|
user.posts.create(FactoryGirl.attributes_for(:post))
end
```

---

## FFaker (Faker refactored)
[Faker][6] is used to easily generate fake data: names, addresses, phone numbers, etc.
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
it "is invalid without an email" do
expect(FactoryGirl.build :user, email: nil).not_to be_valid
end
it "does not allow duplicate emails" do
expect(FactoryGirl.build :user, email: user.email).not_to be_valid
end
it "is invalid without a name" do
expect(FactoryGirl.build :user, name: nil).not_to be_valid
end
end
```

---

## Testing associations
```ruby
describe User do
let(:user) { FactoryGirl.create :user }
it "has many posts" do
expect(user).to respond_to :posts
end
end
```

---

## Testing scopes
```ruby
describe User do
context ".admins" do
before do
@users = FactoryGirl.create_list(:user, 3)
@admins = FactoryGirl.create_list(:admin, 3)
end
it "returns list of admins" do
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
context "change email" do
it "sends email changed notification" do
user.email = FFaker::Internet.email
expect(UserMailer).to receive(:email_changed).with(user).and_return(double("meil", deliver: true))
user.save
end
it "doesn't send email changed notification" do
user.name = "Santa Claus"
expect(UserMailer).not_to receive(:email_changed)
user.save
end
end
end
```

---

## Shoulda matchers
[Shoulda-matchers][7] provides Test::Unit and RSpec-compatible one-liners that test common Rails functionality.
```ruby
group :test do
gem 'shoulda-matchers'
end
```
spec/models/user_spec.rb
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
Business logic structure:
### Book
* Should contain title, descirption, price and how many books in stock
* Title, price, books in stock fields should be required
* Should belong to author and category
* Should have many ratings from costomers
### Category
* Has a title
* Title should be required and unique
* Should have many books
### Author
* Should contain firstname, lastname, biography
* Firstname, lastname fields should be required
* Should have many books
### Rating
* Should contain text review and rating number from one to ten
* Should belong to customer and book
### Customer
* Should contain email, password, firstname, lastname
* Email, password, firstname, lastname fields should be required
* Email should be unique
* Should have many orders, ratings
* A customer should be able to create a new order
* A customer should be able to return a current order in progress
Order
* Should contain total price, completed date and state (in progress/complited/shipped)
* Total price, completed date and state fields should be required
* By default an order should have 'in progress' state
* Should belong to customer and credit card
* Should have many order items
* Should have one billing address and one shipping address
* An order should be able to add a book to the order
* An order should be able to return a total price of the order
OrderItem
* Should contain price and quantity
* Price and quantity fields should be required
* Should belong to book and order
Address
* Should contain address, zipcode, city, phone, country
* All fields should be required
Country
* Should contain a name
* Name should be required and unique
CreditCard
* Should contain number, CVV, expiration month, expiration year, firstname, lastname
* All fields should be required
* Should belong to customer and have many orders
Necessary to create a DB structure, models, associations and validations to models, autotests and factories for
autotests.

[4]: https://github.com/bmabey/database_cleaner
[5]: https://github.com/thoughtbot/factory_girl
[6]: https://github.com/ffaker/ffaker
[7]: https://github.com/thoughtbot/shoulda-matchers
