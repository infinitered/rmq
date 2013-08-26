# -*- encoding: utf-8 -*-

Version = "0.3.0"

Gem::Specification.new do |spec|
  spec.name = 'ruby_motion_query'
  spec.summary = 'RubyMotionQuery - RMQ'
  spec.description = 'RubyMotionQuery - RMQ - A light, nonpolluting, jQuery-like library for RubyMotion' 
  spec.authors = ["Todd Werth", "InfiniteRed"]
  spec.email = 'todd@infinitered.com'
  spec.homepage = "http://infinitered.com/rmq"
  spec.version = Version
  spec.license = 'MIT'

  files = []
  files << 'README.md'
  files << 'LICENSE'
  files.concat(Dir.glob('lib/**/*.rb'))
  files.concat(Dir.glob('motion/**/*.rb'))
  spec.files = files
  
  spec.executables << 'rmq'

  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bacon'
  spec.add_development_dependency 'rake'
end
