require 'mongoid'

# Quiet mongo logs
Mongo::Logger.logger.level = Logger::INFO

Mongoid.load!(File.expand_path('../../mongoid.yml', __FILE__), 'test')
Mongoid.purge!

class MongoidModel
  include Mongoid::Document
  include MinimalTags

  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end
