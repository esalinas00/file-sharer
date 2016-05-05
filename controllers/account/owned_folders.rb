# Sinatra Application Controllers
class FileSharingAPI < Sinatra::Base
  post '/api/v1/accounts/:username/owned_folders/?' do
    begin
      new_folder_data = JSON.parse(request.body.read)
      account = Account.where(username: params[:username]).first
      saved_folder = CreateFolderForOwner.call(account:
        account, name: new_folder_data['name'],
                 folder_url: new_folder_data['folder_url']
      )
      new_location = URI.join(@request_url.to_s + '/',
                              saved_folder.id.to_s).to_s
    rescue => e
      logger.info "FAILED to create new folder: #{e.inspect}"
      halt 400
    end

    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/accounts/:username/owned_folders/?' do
    content_type 'application/json'

    begin
      account = Account.where(username: params[:username]).first
      owned_folders = account.owned_folders
      JSON.pretty_generate(data: owned_folders)
    rescue => e
      logger.info "FAILED to find folders for user #{params[:username]}: #{e}"
      halt 404
    end
  end
end
