# -*- encoding: utf-8 -*-

Version = "0.1"

Gem::Specification.new do |spec|
  spec.name = 'rmq'
  spec.summary = 'RubyMotion Query - A small, light, nonpolluting, jQuery-like library for RubyMotion'
  spec.description = 'RubyMotion Query - A small, light, nonpolluting, jQuery-like library for RubyMotion' 
  spec.authors = ["InfiniteRed", "Todd Werth"]
  spec.email = 'todd@infinitered.com'
  spec.homepage    = "https://github.com/infinitered/rmq"
  spec.version = Version

  #spec.add_dependency "none", "~> 1.0.0"

  files = []
  files << 'README.md'
  files << 'LICENSE'
  files.concat(Dir.glob('lib/**/*.rb'))
  files.concat(Dir.glob('motion/**/*.rb'))
  spec.files = files

  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
