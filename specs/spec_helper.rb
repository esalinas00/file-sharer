ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
Dir.glob('./{config,models,services,controllers}/init.rb').each do |file|
  require file
end

include Rack::Test::Methods

def app
  FileSharingAPI
end

def invalid_id(resource)
  case [resource]
  when [Folder]
    (resource.max(:id) || 0) + 1
  when [SimpleFile]
    SecureRandom.uuid
  else
    raise "INVALID_ID: unknown primary key for #{resource}"
  end
end

def random_str(size)
  chars = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
  chars.sample(size).join
end
