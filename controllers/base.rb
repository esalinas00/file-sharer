require 'sinatra'
require 'json'

# File Sharing Web Service
class FileSharingAPI < Sinatra::Base
  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  configure :production, :development do
    enable :logging
  end

  get '/?' do
    "File Sharer Webservice is up and running at api/v1"
  end

  get '/api/v1/?' do
    # TODO print all api urls as a json
    "Version 1.0 our our api"
  end
end
