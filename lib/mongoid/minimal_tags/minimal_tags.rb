require 'mongoid'

module Mongoid
  module MinimalTags
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def tag_field(field_name, formatter: MinimalTags.default_formatter)
        field field_name, type: Array, default: []
        index field_name => 1

        # Create the scopes for querying tags
        MinimalTags.query_types.each do |type, prefix|
          scope "#{prefix}_#{field_name}", lambda { |tags|
            criteria.send(type, field_name => formatter.normalize(tags))
          }
        end

        # Normalize tags on save
        set_callback(:save, :before) do
          tags = read_attribute(field_name)
          write_attribute(field_name, formatter.normalize(tags))
        end
      end
    end
  end
end
