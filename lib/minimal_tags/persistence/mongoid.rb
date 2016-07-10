module MinimalTags
  module Persistence
    module Mongoid
      TAG_SEARCH_TYPES = {
        all: 'all',
        any: 'in',
        without_all: 'ne',
        without_any: 'nin'
      }

      ##
      # Creates a tag field, index, search methods and a callback for tag
      # normalization on save.
      #
      # @example
      #   class Posts
      #     include Mongoid::Document
      #     include MinimalTags
      #
      #     tag_field :tags
      #   end
      #
      #   doc = Posts.create(tags: ['hello world', 'this is a test']).tags
      #   # => ['hello-world', 'this-is-a-test']
      #
      #   doc == Posts.any_tags(['HELLO WORLD']).first
      #   # => true
      #
      # @param [String] field_name The field name to use in mongo and searching methods
      # @param [Object] formatter The formatter to use, overriding the default
      def tag_field(field_name, formatter: MinimalTags.default_formatter)
        field field_name, type: Array, default: []
        index field_name => 1

        # Create the scopes for searching tags
        TAG_SEARCH_TYPES.each do |prefix, type|
          scope "#{prefix}_#{field_name}", lambda { |tags|
            criteria.send(type, field_name => formatter.normalize(tags))
          }
        end

        tag_fields << field_name

        # Normalize tags on save
        set_callback(:save, :before) do
          tags = read_attribute(field_name) || []
          write_attribute(field_name, formatter.normalize(tags))
        end
      end
    end
  end
end
