require 'mongoid/minimal_tags/minimal_tags'
require 'mongoid/minimal_tags/simple_formatter'
require 'mongoid/minimal_tags/version'

module Mongoid
  module MinimalTags
    class << self
      attr_writer :default_formatter

      DEFAULT_SEARCH_TYPES = {
        all: 'all',
        in: 'any',
        nin: 'without_any'
      }

      def default_formatter
        @default_formatter ||= SimpleFormatter.new
      end

      def search_types
        @search_types ||= DEFAULT_SEARCH_TYPES
      end
    end
  end
end
