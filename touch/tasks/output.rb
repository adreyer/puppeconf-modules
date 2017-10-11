#!/opt/puppetlabs/puppet/bin/ruby
#touch/tasks/output.rb

require 'json'
require 'fileutils'

params = JSON.parse(STDIN.read)

result = {}
result['files'] = params['files'].reduce({}) do |files, filename|
  files[filename] = {}
  files[filename]['new'] = !File.exists?(filename)
  FileUtils.touch(filename)
  files[filename]['success'] = true
  files
end

result['_output'] = "Successfully touched all files."
STDOUT.puts(result.to_json)
