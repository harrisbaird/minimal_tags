module MinimalTags
  module Persistence
    module Sequel
      TAG_SEARCH_TYPES = {
        all: :contains,
        any: :overlaps
      }

      ##
      # Creates a tag field, index, search methods and a callback for tag
      # normalization on save.
      #
      # @example
      #   class Post < Sequel::Model
      #     include MinimalTags
      #
      #     tag_field :tags
      #   end
      #
      #   doc = Post.create(tags: ['hello world', 'this is a test']).tags
      #   # => ['hello-world', 'this-is-a-test']
      #
      #   doc == Post.any_tags(['HELLO WORLD']).first
      #   # => true
      #
      # @param [String] field_name The field name to use in mongo and searching methods
      # @param [Object] formatter The formatter to use, overriding the default
      def tag_field(field_name, formatter: MinimalTags.default_formatter)
        # Create the scopes for searching tags
        TAG_SEARCH_TYPES.each do |prefix, operator|
          define_singleton_method "#{prefix}_#{field_name}" do |tags|
            formatted_tags = formatter.normalize(tags)
            query = ::Sequel.pg_array_op(field_name).send(operator, formatted_tags)
            where(query)
          end

          define_singleton_method "without_#{prefix}_#{field_name}" do |tags|
            formatted_tags = formatter.normalize(tags)
            query = ::Sequel.pg_array_op(field_name).send(operator, formatted_tags)
            exclude(query)
          end
        end

        tag_fields << field_name

        # # Normalize tags on save
        before_save do |*args|
          tags = send(field_name) || []
          send("#{field_name}=", formatter.normalize(tags))
        end
      end
    end
  end
end
