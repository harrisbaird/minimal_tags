require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  encoding: 'unicode',
  database: 'minimal_tags',
  username: 'postgres'
)

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  drop_table 'posts' if ActiveRecord::Base.connection.table_exists? 'posts'

  create_table :posts do |t|
    t.string :tags, array: true, default: '{}'
    t.string :upcase_tags, array: true, default: '{}'
    t.string :reverse_tags, array: true, default: '{}'
  end
end

class ActiveRecordModel < ActiveRecord::Base
  include MinimalTags

  self.table_name = 'posts'

  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end
