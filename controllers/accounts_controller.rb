class FileSharingAPI < Sinatra::Base
  get '/api/v1/accounts/?' do
    # TODO return all accounts' files
    content_type 'application/json'

    JSON.pretty_generate(data: Account.all)
  end

  get '/api/v1/accounts/:username' do
    content_type 'application/json'

    username = params[:username]
    user = Account.where(username: username)
                  .first

    files = user ? Account[user.id].simple_files : []

    if user
      JSON.pretty_generate(data: user, relationships: files)
    else
      halt 404, "USER NOT FOUND: #{username}"
    end
  end

  post '/api/v1/accounts/?' do
    begin
      data = JSON.parse(request.body.read)
      new_account = CreateNewAccount.call(
        username: data['username'],
        email: data['email'],
        password: data['password'])
    rescue => e
      logger.info "FAILED to create new user: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.username).to_s

    status 201
    headers('Location' => new_location)
  end
end
