require 'rubygems'
require 'rake'
require 'rake/clean'

CLOBBER.include ['pkg', '*.gem', 'doc', 'coverage', 'measurements']

task :install_fast do
  sh "rake build; gem install pkg/dm-mongo-adapter*.gem --local"
end
