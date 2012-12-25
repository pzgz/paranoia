# Paranoia

Paranoia is a re-implementation of [acts\_as\_paranoid](http://github.com/technoweenie/acts_as_paranoid) for Rails 3, using much, much, much less code.

You would use either plugin / gem if you wished that when you called `destroy` on an Active Record object that it didn't actually destroy it, but just "hid" the record. Paranoia does this by setting a `deleted` field to true when you `destroy` a record, and hides it by scoping all queries on your model to only include records which do not have a `deleted` field.

## Why fork and why this branch

In my project, originally, I added ```deleted``` column for tables, which is a ```boolean``` field, I used this column to indicate if the record has been deleted or not. Also, I used updated_at column to identify the record deleting timestamp. So I have to make sure this column get updated when a record has been marked as deleted. It's not easy for me to change codes in all of my project after I discover this plugin.

That's why I forked the original repo and made this branch.

Maybe, a better idea is to extend this gem, to make sure we can customize the field name and field type to be used for deleted indicator.

## Test

Be aware, tests haven't been updated to fit the changes.

## Installation & Usage

Put this in your Gemfile:

```ruby
gem 'paranoia'
```

Then run `bundle`. Done.

Updating is as simple as `bundle update paranoia`.

#### Rails 3

In your _Gemfile_:

```ruby
gem 'paranoia'
```

Then run:

```shell
bundle install
```

#### Rails 2:

In your _config/environment.rb_:

```ruby
config.gem 'paranoia'
```

Then run:

```shell
rake gems:install
```

#### Run your migrations for the desired models

```ruby
class AddDeletedAtToClient < ActiveRecord::Migration
  def self.up
    add_column :clients, :`deleted`, :boolean, :default => false
  end

  def self.down
    remove_column :clients, :deleted
  end
end
```
    
### Usage

#### In your model:

```ruby
class Client < ActiveRecord::Base
  acts_as_paranoid

  ...
end
```

Hey presto, it's there!

If you want a method to be called on destroy, simply provide a _before\_destroy_ callback:

```ruby
class Client < ActiveRecord::Base
  acts_as_paranoid

  before_destroy :some_method

  def some_method
    # do stuff
  end

  ...
end
```

You can replace the older acts_as_paranoid methods as follows:

```ruby
find_with_deleted(:all)       # => with_deleted
find_with_deleted(:first)     # => with_deleted.first
find_with_deleted(id)         # => with_deleted.find(id)

find_only_deleted(:all)       # => only_deleted, or deleted
find_only_deleted(:first)     # => only_deleted.first, or deleted.first
find_only_deleted(id)         # => only_deleted.find(id), or deleted.find(id)
```

## License

This gem is released under the MIT license.