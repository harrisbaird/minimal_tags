# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minimal_tags/version'

Gem::Specification.new do |spec|
  spec.name          = 'minimal_tags'
  spec.version       = MinimalTags::VERSION
  spec.authors       = ['harrisbaird']
  spec.email         = ['mydancake@gmail.com']

  spec.summary       = 'Simple tag fields for ActiveRecord and Mongoid.'
  spec.description   = 'Simple tag fields for ActiveRecord and Mongoid.'
  spec.homepage      = 'https://github.com/harrisbaird/minimal_tags'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'mongoid', '>= 5.0.0', '<= 6.0.0'
  spec.add_development_dependency 'activerecord', '>= 4.0.0', '<= 6.0.0'
  spec.add_development_dependency 'sequel', '<= 5.0.0'
  spec.add_development_dependency 'pg'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
