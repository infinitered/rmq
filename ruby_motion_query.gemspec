# -*- encoding: utf-8 -*-

$:.push File.expand_path("../motion", __FILE__)
require "ruby_motion_query/version"

Gem::Specification.new do |spec|
  spec.name = 'ruby_motion_query'
  spec.summary = 'RubyMotionQuery - RMQ'
  spec.description = 'RubyMotionQuery - RMQ - A fast, non-magical, non-polluting, jQuery-like front-end library for RubyMotion'
  spec.authors = ["Todd Werth", "InfiniteRed"]
  spec.email = 'todd@infinitered.com'
  spec.homepage = "http://rubymotionquery.com"
  spec.version = RubyMotionQuery::VERSION
  spec.license = 'MIT'

  files = []
  files << 'README.md'
  files << 'LICENSE'
  files.concat(Dir.glob('lib/**/*.rb'))
  files.concat(Dir.glob('motion/**/*.rb'))
  files.concat(Dir.glob('templates/**/*.rb'))
  spec.files = files

  spec.executables << 'rmq'

  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bacon'
  spec.add_development_dependency 'rake'
end
