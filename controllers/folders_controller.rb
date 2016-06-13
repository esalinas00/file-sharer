class FileSharingAPI < Sinatra::Base
  def affiliated_folder(env, folder_id)
    account = authenticated_account(env)
    all_projects = FindAllAccountFolders.call(id: account['id'])
    all_projects.select { |proj| proj.id == folder_id.to_i }.first
  rescue
    nil
  end

  get '/api/v1/folders/:id' do
    content_type 'application/json'
    folder_id = params[:id]
    folder = affiliated_folder(env, folder_id)
    halt(401, 'Not authorized, or folder might not exist') unless folder
    JSON.pretty_generate(data: folder, relationships: folder.simple_files)
  end

  post '/api/v1/folders/:folder_id/collaborator/:collaborator_id' do
    begin
      collaborator_id = params[:collaborator_id]
      folder_id = params[:folder_id]
      result = AddCollaboratorForFolder.call(
        collaborator_id: collaborator_id,
        folder_id: folder_id)
      status result ? 201 : 403
    rescue => e
      logger.info "FAILED to add collaborator to folder: #{e.inspect}"
      halt 400
    end
  end
end
