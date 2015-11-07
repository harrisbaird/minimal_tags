require 'mongoid'

module Mongoid
  module MinimalTags
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      ##
      # Creates a tag field, index, search methods and a callback for tag
      # normalization on save.
      #
      # @example
      #   class Document
      #     include Mongoid::Document
      #     include Mongoid::MinimalTags
      #
      #     tag_field :tags
      #   end
      #
      #   doc = Document.create(tags: ['hello world', 'this is a test']).tags
      #   # => ['hello-world', 'this-is-a-test']
      #
      #   doc == Document.any_tags(['HELLO WORLD']).first
      #   # => true
      #
      # @param [String] field_name The field name to use in mongo and searching methods
      # @param [Object] formatter The formatter to use, overriding the default
      def tag_field(field_name, formatter: MinimalTags.default_formatter)
        field field_name, type: Array, default: []
        index field_name => 1

        # Create the scopes for searching tags
        MinimalTags.search_types.each do |type, prefix|
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
