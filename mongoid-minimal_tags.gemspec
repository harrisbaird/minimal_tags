# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/minimal_tags/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid-minimal_tags'
  spec.version       = Mongoid::MinimalTags::VERSION
  spec.authors       = ['harrisbaird']
  spec.email         = ['mydancake@gmail.com']

  spec.summary       = 'Simple tag fields for mongodb documents.'
  spec.description   = 'Simple tag fields for mongodb documents.'
  spec.homepage      = 'https://github.com/harrisbaird/mongoid-minimal_tags'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mongoid', '>= 4.0.0', '<= 6.0.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
