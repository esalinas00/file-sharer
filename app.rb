require 'sinatra'
require 'json'
require_relative 'config/environments'
require_relative 'models/init'

class FileSharingAPI < Sinatra::Base

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    "File Sharer Webservice is up and running at api/v1"
  end

  get '/api/v1/?' do
    # TODO print all api urls as a json
    "Version 1.0 our our api"
  end

  get '/api/v1/users/?' do
    # TODO return all users' files
    content_type 'application/json'

    JSON.pretty_generate(data: User.all)
  end

  get '/api/v1/users/:username' do
    content_type 'application/json'

    username = params[:username]
    user = User[username]
    files = user ? User[username].files : []

    if user
      JSON.pretty_generate(data: user, relationships: files)
    else
      halt 404, "USER NOT FOUND: #{username}"
    end
  end



  get '/api/v1/files/?' do
    # TODO return all users' files
    content_type 'application/json'

    JSON.pretty_generate(data: SimpleFile.all)
  end

  get '/api/v1/files/:id.json' do
    # TODO return specific file
    content_type 'application/json'

    begin
      { file: SimpleFile.find(params[:id]) }.to_json
    rescue => e
      status 404
      logger.info "FAILED to GET file: #{e.inspect}"
    end
  end

  get '/api/v1/files/:id/attribute' do
    # TODO return a particular attribute of a file
    content_type 'application/json'

  end

  post '/api/v1/files' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_file = SimpleFile.new(new_data)
      if new_file.save
        logger.info "NEW FILE"
      else
        halt 400, "Could not store a file: #{new_file.id}"
      end

      redirect '/api/v1/files/' + new_file.id + '.json'
    rescue => e
      status 400
      logger.info "FAILED to create new file: #{e.inspect}"
    end

  end

end
