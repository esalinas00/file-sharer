class FileSharingAPI < Sinatra::Base
  get '/api/v1/accounts/:username' do
    content_type 'application/json'

    username = params[:username]
    account = Account.where(username: username).first

    if account
      folders = account.owned_folders
      JSON.pretty_generate(data: account, relationships: folders)
    else
      halt 404, "FOLDER NOT FOUND: #{username}"
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
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.username).to_s

    status 201
    headers('Location' => new_location)
  end

  post '/api/v1/accounts/:username/folders/?' do
    begin
      username = params[:username]
      new_data = JSON.parse(request.body.read)

      account = Account.where(username: username).first
      saved_folder = account.add_owned_folder(name: new_data['name'])
      saved_folder.folder_url = new_data['folder_url'] if new_data['folder_url']
      saved_folder.save
    rescue => e
      logger.info "FAILED to create new folder: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_folder.id.to_s).to_s

    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/accounts/:username/folders/?' do
    content_type 'application/json'

    begin
      username = params[:username]
      account = Account.where(username: username).first

      my_folders = Folder.where(owner_id: account.id).all
      other_folders = Folder.join(:accounts_folders, folder_id: :id)
                            .where(collaborator_id: account.id).all

      all_folders = my_folders + other_folders
      JSON.pretty_generate(data: all_folders)
    rescue => e
      logger.info "FAILED to get folders for #{username}: #{e}"
      halt 404
    end
  end

  # get '/api/v1/accounts/?' do
  #   # TODO return all accounts' files
  #   content_type 'application/json'
  #
  #   JSON.pretty_generate(data: Account.all)
  # end
  #
  # get '/api/v1/accounts/:username' do
  #   content_type 'application/json'
  #
  #   username = params[:username]
  #   user = Account.where(username: username)
  #                 .first
  #
  #   files = user ? Account[user.id].simple_files : []
  #
  #   if user
  #     JSON.pretty_generate(data: user, relationships: files)
  #   else
  #     halt 404, "USER NOT FOUND: #{username}"
  #   end
  # end
  #
  # post '/api/v1/accounts/?' do
  #   begin
  #     data = JSON.parse(request.body.read)
  #     new_account = CreateNewAccount.call(
  #       username: data['username'],
  #       email: data['email'],
  #       password: data['password'])
  #   rescue => e
  #     logger.info "FAILED to create new user: #{e.inspect}"
  #     halt 400
  #   end
  #
  #   new_location = URI.join(@request_url.to_s + '/', new_account.username).to_s
  #
  #   status 201
  #   headers('Location' => new_location)
  # end
end
