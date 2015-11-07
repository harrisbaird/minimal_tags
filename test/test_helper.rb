$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'mongoid/minimal_tags'

# Quiet mongo logs
Mongo::Logger.logger.level = Logger::INFO

Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__), 'test')
Mongoid.purge!

require 'database_cleaner'
class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

class UpcaseFormatter
  def normalize(tags)
    tags.map(&:upcase)
  end
end

class ReverseFormatter
  def normalize(tags)
    tags.map(&:reverse)
  end
end

class Document
  include Mongoid::Document
  include Mongoid::MinimalTags

  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end

Mongoid::MinimalTags.default_formatter = ReverseFormatter.new

class ReverseDocument
  include Mongoid::Document
  include Mongoid::MinimalTags

  tag_field :tags
end
