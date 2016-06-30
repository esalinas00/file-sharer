class FileSharingAPI < Sinatra::Base
  def authorized_affiliated_folder(env, folder_id)
    account = authenticated_account(env)
    all_folders = FindAllAccountFolders.call(id: account['id'])
    all_folders.select { |proj| proj.id == folder_id.to_i }.first
  rescue
    nil
  end

  def authorized_affiliated_folderByName(env, folder_name)
    account = authenticated_account(env)
    all_folders = FindAllAccountFolders.call(id: account['id'])
    all_folders.select { |proj| proj.name == folder_name }.first
  rescue
    nil
  end

  get '/api/v1/folders/:id' do
    content_type 'application/json'
    folder_id = params[:id]
    folder = authorized_affiliated_folder(env, folder_id)
    halt(401, 'Not authorized, or folder might not exist') unless folder
    folder.to_full_json
    # JSON.pretty_generate(data: folder, relationships: folder.simple_files)
  end

  get '/api/v1/foldersByName/:name' do
    content_type 'application/json'
    folder_name = params[:name]
    folder = authorized_affiliated_folderByName(env, folder_name)
    halt(401, 'Not authorized, or folder might not exist') unless folder
    folder.to_full_json
    # JSON.pretty_generate(data: folder, relationships: folder.simple_files)
  end

  post '/api/v1/folders/:folder_id/collaborators/?' do
    content_type 'application/json'
    begin
      criteria = JSON.parse request.body.read
      collaborator = FindBaseAccountByEmail.call(criteria['email'])
      folder = authorized_affiliated_folder(env, params[:folder_id])
      raise('Unauthorized or not found') unless folder && collaborator

      # collaborator_id = params[:collaborator_id]
      # folder_id = params[:folder_id]
      collaborator = AddCollaboratorForFolder.call(
        collaborator_id: collaborator.id,
        folder_id: folder.id)
      collaborator ? status(201) : raise('Could not add collaborator')
    rescue => e
      logger.info "FAILED to add collaborator to folder: #{e.inspect}"
      halt 400
    end
    collaborator.to_json
  end
end
