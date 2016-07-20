require 'minimal_tags/simple_formatter'
require 'minimal_tags/version'

module MinimalTags
  class << self
    attr_writer :default_formatter

    def included(base)
      ancestors = base.ancestors.collect(&:to_s)
      base.send :extend, ClassMethods

      if ancestors.include?('Mongoid::Document')
        require 'minimal_tags/persistence/mongoid'
        base.send :extend, Persistence::Mongoid
      elsif ancestors.include?('ActiveRecord::Base')
        require 'minimal_tags/persistence/activerecord'
        base.send :extend, Persistence::Activerecord
      elsif ancestors.include?('Sequel::Model')
        require 'minimal_tags/persistence/sequel'
        base.plugin :hook_class_methods
        base.send :extend, Persistence::Sequel
      end
    end

    def default_formatter
      @default_formatter ||= SimpleFormatter.new
    end

    module ClassMethods
      def tag_fields
        @tag_fields ||= []
      end
    end
  end
end
