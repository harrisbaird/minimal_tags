[![Build Status](https://travis-ci.org/harrisbaird/mongoid-minimal_tags.svg?branch=master)](https://travis-ci.org/harrisbaird/mongoid-minimal_tags)
[![Code Climate](https://codeclimate.com/github/harrisbaird/mongoid-minimal_tags/badges/gpa.svg)](https://codeclimate.com/github/harrisbaird/mongoid-minimal_tags)
[![Test Coverage](https://codeclimate.com/github/harrisbaird/mongoid-minimal_tags/badges/coverage.svg)](https://codeclimate.com/github/harrisbaird/mongoid-minimal_tags/coverage)
[![Inline docs](http://inch-ci.org/github/harrisbaird/mongoid-minimal_tags.svg?branch=master)](http://inch-ci.org/github/harrisbaird/mongoid-minimal_tags)

---

# Mongoid::MinimalTags

Mongoid::MinimalTags is a tiny gem for adding tagging support to [Mongoid](https://github.com/mongodb/mongoid) documents.

Multiple tag fields can be used, each with their own way of formatting.

## Installation

Add to your Gemfile:

```ruby
gem 'mongoid-minimal_tags'
```

## Usage

Start by including the `Mongoid::MinimalTags` module and define your tag fields
with the `tag_field` method.

```ruby
class Document
  include Mongoid::Document
  include Mongoid::MinimalTags

  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end
```

You can define multiple tag fields, just ensure they have unique names.  
Formatters can be defined on each tag field if needed, otherwise the default be used.

## Searching
The following scopes are also added for each tag field:
`.any_*`, `.all_*`, `.without_any_*`  
All scopes return a `Mongoid::Criteria` and can be chained.

```ruby
Document.any_tags(['a', 'b', 'c'])
Document.all_tags(['a', 'b', 'c'])
Document.without_any_tags(['a', 'b', 'c'])
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
