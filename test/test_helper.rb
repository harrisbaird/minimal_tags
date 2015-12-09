$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'minimal_tags'

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

Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }
