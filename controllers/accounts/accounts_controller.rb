class FileSharingAPI < Sinatra::Base
  get '/api/v1/accounts/:username' do
    content_type 'application/json'

    username = params[:username]
    account = BaseAccount.where(username: username).first

    if account
      id = account.id
      JSON.pretty_generate(id: id)
    else
      halt 404, "USER ID NOT FOUND: #{username}"
    end
  end

  get '/api/v1/accounts/:id' do
    content_type 'application/json'

    id = params[:id]
    halt 401 unless authorized_account?(env, id)
    account = Account.where(id: id).first

    if account
      folders = account.owned_folders
      JSON.pretty_generate(data: account, relationships: folders)
    else
      halt 404, "FOLDER NOT FOUND: #{id}"
    end
  end

  post '/api/v1/accounts/?' do
    # TODO: only allow authorized client apps
    begin
      data = JSON.parse(request.body.read)
      new_account = CreateAccount.call(
        username: data['username'],
        email: data['email'],
        password: data['password'])
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.username).to_s

    status 201
    headers('Location' => new_location)
  end

  post '/api/v1/accounts/:id/pk/?' do
    content_type 'application/json'
    begin
      new_data = JSON.parse(request.body.read)
      saved_pk = ImportPK.call(
        account_id: params[:id],
        pk: new_data['public_key'])
    rescue => e
      logger.info "FAILED to import new file: #{e.inspect}"
      halt 400
    end

    status 201
    saved_pk.to_json
  end
end
