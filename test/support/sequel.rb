require 'sequel'

DB = Sequel.connect('postgres://postgres@localhost/minimal_tags')
DB.extension :pg_array
Sequel.extension :pg_array_ops

class SequelModel < Sequel::Model(:posts)
  include MinimalTags
  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end
