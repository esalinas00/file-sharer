class FileSharingAPI < Sinatra::Base
  get '/api/v1/users/:username/files/?' do
    # returns a json of all files for a user
    content_type 'application/json'

    username = params[:username]
    user = User.where(username: username)
               .first

    JSON.pretty_generate(data: user.simple_files)
  end

  get '/api/v1/users/:username/files/:id.json/?' do
    # Returns a json of all information about a file
    content_type 'application/json'

    username = params[:username]
    user_id = User.where(username: username)
                  .first
                  .id

    begin
      doc_url = URI.join(@request_url.to_s + '/', 'document')
      simple_file = SimpleFile
                      .where(user_id: user_id, id: params[:id])
                      .first
      halt(404, 'File not found') unless simple_file
      JSON.pretty_generate(data: {
                             file: simple_file,
                             links: { document: doc_url }
                           })
    rescue => e
      status 400
      logger.info "FAILED to process GET file request: #{e.inspect}"
      e.inspect
    end
  end

  get '/api/v1/users/:username/files/:id/document' do
    # Returns a text/plain document with a configuration document
    content_type 'text/plain'

    username = params[:username]
    user_id = User.where(username: username)
                  .first
                  .id
    begin
      # Return raw data
      SimpleFile
        .where(user_id: user_id, id: params[:id])
        .first
        .document
    rescue => e
      status 404
      e.inspect
    end
  end

  post '/api/v1/users/:username/files/?' do
    # Creates a new file for a user
    # TODO Should upload here
    username = params[:username]
    begin
      # Find a user
      user = User.where(username: username)
                 .first

      new_data = JSON.parse(request.body.read)
      document_plaintext = new_data.delete('document_plaintext')
      saved_file = user.add_simple_file(new_data)
      saved_file.document = document_plaintext
      saved_file.save
    rescue => e
      logger.info "FAILED to create new file: #{e.inspect}"
      halt 400
    end

    status 201
    new_location = URI.join(@request_url.to_s + '/', saved_file.id.to_s).to_s
    headers('Location' => new_location)
  end
end
