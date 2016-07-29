[![Build Status](https://travis-ci.org/harrisbaird/minimal_tags.svg?branch=master)](https://travis-ci.org/harrisbaird/minimal_tags)
[![Code Climate](https://codeclimate.com/github/harrisbaird/minimal_tags/badges/gpa.svg)](https://codeclimate.com/github/harrisbaird/minimal_tags)
[![Test Coverage](https://codeclimate.com/github/harrisbaird/minimal_tags/badges/coverage.svg)](https://codeclimate.com/github/harrisbaird/minimal_tags/coverage)
[![Inline docs](http://inch-ci.org/github/harrisbaird/minimal_tags.svg?branch=master)](http://inch-ci.org/github/harrisbaird/minimal_tags)

---

# MinimalTags

MinimalTags is a tiny gem for adding tagging support to [Mongoid](https://github.com/mongodb/mongoid), [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) and [Sequel](http://sequel.jeremyevans.net/).

Multiple tag fields can be used, each with their own way of formatting.

**Please Note: ActiveRecord and Sequel both require PostgreSQL.**

## Installation

Add to your Gemfile:

```ruby
gem 'minimal_tags'
```

### Mongoid
There is nothing else to add, fields will be created when you define your tag fields.

### ActiveRecord

Add the following migration for each tag field you want.

```ruby
class AddTagsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :tags, :text, default: [], null: false, array: true
    add_index :posts, :tags, using: :gin
  end
end

```

### Sequel

Add the following migration for each tag field you want.

```ruby
Sequel.migration do
  change do
    add_column :posts, :tags, 'text[]', default: [], null: false
    add_index :posts, :tags, type: :gin
  end
end

```

Also enable the `pg_array` and `pg_array_ops` extensions:

```ruby
DB = Sequel.connect('postgres://...')
DB.extension :pg_array
Sequel.extension :pg_array_ops
```

## Usage

Start by including the `MinimalTags` module and define your tag fields
with the `tag_field` method.

```ruby
class Document
  include Mongoid::Document
  include MinimalTags

  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end
```

You can define multiple tag fields, just ensure they have unique names.  
Formatters can be defined on each tag field if needed, otherwise the default, [MinimalTags::SimpleFormatter](https://github.com/harrisbaird/minimal_tags/blob/master/lib/minimal_tags/simple_formatter.rb) will be used.

### Changing the default formatter

```ruby
MinimalTags.default_formatter = UnderscoreTagFormatter.new
```

## Searching
The following scopes are also added for each tag field and can be chained:
`.any_*`, `.all_*`, `.without_any_*`, `.without_all_*`

```ruby
Document.any_tags(['a', 'b', 'c'])
Document.all_tags(['a', 'b', 'c'])
Document.without_any_tags(['a', 'b', 'c'])
Document.without_all_tags(['a', 'b', 'c'])
```

### Partial tags

**Sequel only for now**

Find with partial tag match:

```ruby
Document.partial_tags('hello').all
```

Array of matching tags:

```ruby
Document.partial_tags('hello').select_map(:mt_tags)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
