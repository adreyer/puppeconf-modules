#!/opt/puppetlabs/puppet/bin/ruby
#touch/tasks/array.rb

require 'json'
require 'fileutils'

params = JSON.parse(STDIN.read)

params['files'].each do |filename|
  FileUtils.touch(filename)
  puts "Updated file #{filename}"
end
