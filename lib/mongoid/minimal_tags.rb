require 'mongoid/minimal_tags/minimal_tags'
require 'mongoid/minimal_tags/simple_formatter'
require 'mongoid/minimal_tags/version'

module Mongoid
  module MinimalTags
    class << self
      attr_writer :default_formatter

      DEFAULT_QUERY_TYPES = {
        all: 'all',
        in: 'any',
        nin: 'without_any'
      }

      def default_formatter
        @default_formatter ||= SimpleFormatter.new
      end

      def query_types
        @query_types ||= DEFAULT_QUERY_TYPES
      end
    end
  end
end
