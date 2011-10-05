#!/usr/bin/env ruby

require 'fileutils'

tmpdir = File.expand_path(File.join(File.dirname(__FILE__),'..','tmp'))
dbpath = File.join(tmpdir,'mongodb')

if File.exists? dbpath
  puts "removing dbpath: #{dbpath}"
  FileUtils.rm_rf dbpath
end

unless File.exists? dbpath
  puts "creating dbpath: #{dbpath}"
  FileUtils.mkdir_p dbpath
end

command = %W(mongod -dbpath #{dbpath} -noprealloc -nojournal -noauth -port 26016 -bind_ip 127.0.0.1)

puts "executing: #{command.join(' ')}"
puts '************************************************************'
puts 'Run specs: $ MONGO_URL=mongo://127.0.0.1:26016 bundle exec spec spec'
puts '************************************************************'
Kernel.exec *command
