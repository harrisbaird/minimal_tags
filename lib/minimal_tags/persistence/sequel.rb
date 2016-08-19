module MinimalTags
  module Persistence
    module Sequel
      TAG_SEARCH_TYPES = {
        all: :contains,
        any: :overlaps
      }

      TAG_PREFIX_TYPES = {
        where: '',
        exclude: 'without_'
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
      # @param [String] field_name The field name to use
      # @param [Object] formatter The formatter to use, overriding the default
      def tag_field(field_name, formatter: MinimalTags.default_formatter)
        # Create the scopes for searching tags
        TAG_SEARCH_TYPES.each do |prefix, operator|
          TAG_PREFIX_TYPES.each do |method, without_prefix|
            def_dataset_method "#{without_prefix}#{prefix}_#{field_name}" do |tags|
              normalized_tags = formatter.normalize(tags)
              normalized_tags = ::Sequel.pg_array(normalized_tags, :text)
              query = ::Sequel.pg_array_op(field_name).send(operator, normalized_tags)
              send(method, query)
            end
          end
        end

        define_singleton_method "partial_#{field_name}" do |term|
          select_all(table_name)
            .from(table_name, ::Sequel.pg_array_op(field_name).unnest.as(:mt_tags))
            .grep(:mt_tags, "%#{term}%")
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
