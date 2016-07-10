require 'minimal_tags/simple_formatter'
require 'minimal_tags/version'

module MinimalTags
  class << self
    attr_writer :default_formatter

    def included(base)
      ancestors = base.ancestors.collect(&:to_s)

      base.instance_variable_set('@tag_fields', [])

      if ancestors.include?('Mongoid::Document')
        require 'minimal_tags/persistence/mongoid'
        base.send :extend, Persistence::Mongoid
      elsif ancestors.include?('ActiveRecord::Base')
        require 'minimal_tags/persistence/activerecord'
        base.send :extend, Persistence::Activerecord
      end
    end

    def default_formatter
      @default_formatter ||= SimpleFormatter.new
    end
  end
end
