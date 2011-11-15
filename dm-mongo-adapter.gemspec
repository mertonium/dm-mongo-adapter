# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-mongo-adapter/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'dm-mongo-adapter'
  s.version = DataMapper::Mongo::VERSION

  s.authors  = ['Piotr Solnica']
  s.email    = 'piotr.solnica@gmail.com'
  s.date     = '2011-09-29'
  s.summary  = 'MongoDB DataMapper Adapter'
  s.homepage = 'http://github.com/solnic/dm-mongo-adapter'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(LICENSE README.rdoc TODO)

  s.rubygems_version = '1.8.10'

  s.add_runtime_dependency(%q<mongo>,         ['>= 1.3.0'])
  s.add_runtime_dependency(%q<mongo>,         ['<= 1.4.0'])
  s.add_runtime_dependency(%q<dm-core>,       ['~> 1.3.0.beta'])
  s.add_runtime_dependency(%q<dm-migrations>, ['~> 1.3.0.beta'])
  s.add_runtime_dependency(%q<dm-aggregates>, ['~> 1.3.0.beta'])

  s.add_development_dependency(%q<rake>,      ['~> 0.8.7'])
  s.add_development_dependency(%q<rspec>,     ['~> 1.3.1'])
end
