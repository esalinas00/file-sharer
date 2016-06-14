# Sinatra Application Controllers
class FileSharingAPI < Sinatra::Base
  post '/api/v1/accounts/:owner_id/folders/?' do
    content_type 'application/json'

    begin
      # halt 401 unless authorized_account?(env, params[:owner_id])

      new_folder_data = JSON.parse(request.body.read)
      saved_folder = CreateFolderForOwner.call(
        owner_id: params[:owner_id],
        name: new_folder_data['name'],
        folder_url: new_folder_data['folder_url']
      )

    rescue => e
      logger.info "FAILED to create new folder: #{e.inspect}"
      halt 400
    end

    status 201
    saved_folder.to_json
  end

  # get '/api/v1/accounts/:owner_id/owned_folders/?' do
  #   content_type 'application/json'
  #
  #   begin
  #     owner = Account[params[:owner_id]]
  #     JSON.pretty_generate(data: owner.owned_folders)
  #   rescue => e
  #     logger.info "FAILED to find folders for user #{params[:owner_id]}: #{e}"
  #     halt 404
  #   end
  # end
end
