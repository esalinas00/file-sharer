require 'sinatra'
require 'json'
require_relative 'models/simple_file'

class FileSharingAPI < Sinatra::Base

  before do
    SimpleFile.setup
  end

  get '/?' do
    "File Sharer Webservice is up and running at api/v1/"
  end

  get '/api/v1/?' do
    # TODO print all api urls as a json
    "Version 1.0 our our api"
  end

  get '/api/v1/files/:username/file/:file_id/?' do
    # TODO return specific file
    "#{params['username']} - #{params['file_id']}"
  end

  get '/api/v1/files/:username/?' do
    # TODO return all users' files
    params['username']
  end

  post '/api/v1/files/?' do
    content_type 'application/json'
    new_data = JSON.parse(request.body.read)
    owner = new_data.owner
    file_name = new_data.file_name
    # TODO create files
    JSON.generate(new_data)
  end

  put '/api/v1/files/?' do
    content_type 'application/json'
    new_data = JSON.parse(request.body.read)
    owner = new_data.owner
    file_name = new_data.file_name
    # TODO update files
    JSON.generate(new_data)
  end
end
