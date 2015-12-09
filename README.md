[![Build Status](https://travis-ci.org/harrisbaird/minimal_tags.svg?branch=master)](https://travis-ci.org/harrisbaird/minimal_tags)
[![Code Climate](https://codeclimate.com/github/harrisbaird/minimal_tags/badges/gpa.svg)](https://codeclimate.com/github/harrisbaird/minimal_tags)
[![Test Coverage](https://codeclimate.com/github/harrisbaird/minimal_tags/badges/coverage.svg)](https://codeclimate.com/github/harrisbaird/minimal_tags/coverage)
[![Inline docs](http://inch-ci.org/github/harrisbaird/minimal_tags.svg?branch=master)](http://inch-ci.org/github/harrisbaird/minimal_tags)

---

# MinimalTags

MinimalTags is a tiny gem for adding tagging support to [Mongoid](https://github.com/mongodb/mongoid)  and ActiveRecord (Currently only Postgresql).

Multiple tag fields can be used, each with their own way of formatting.

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
Formatters can be defined on each tag field if needed, otherwise the default be used.

## Searching
The following scopes are also added for each tag field and can be chained:
`.any_*`, `.all_*`

```ruby
Document.any_tags(['a', 'b', 'c'])
Document.all_tags(['a', 'b', 'c'])
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
