#!/opt/puppetlabs/puppet/bin/ruby
# touch/tasks/noop.rb

require 'json'
require 'fileutils'

params = JSON.parse(STDIN.read)

exitcode = 0
result = {}
result['files'] = params['files'].reduce({}) do |files, filename|
  begin
    files[filename] = {}
    files[filename]['new'] = !File.exists?(filename)
    if params['_noop']
      raise StandardError.new "#{filename} isn't writable" unless File.writable?(filename)
    else
      FileUtils.touch(filename)
    end
    files[filename]['success'] = true
  rescue StandardError => e
    exitcode = 1
    files[filename]['success'] = false
    files[filename]['error'] = e.message
  end
  files
end

if exitcode == 0
  result['_output'] = "Successfully touched all files."
  STDOUT.puts(result.to_json)
else
  errored_files = result.map { |filename, r| filename unless r[:success] }.compact
  STDOUT.puts({ _error: {
    kind: 'example_tasks/file-error',
    msg: "Failed to update files: #{errored_files.join(',')}",
    details: { files: result['files'] } } }.to_json)
end

exit exitcode
