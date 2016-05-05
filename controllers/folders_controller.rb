class FileSharingAPI < Sinatra::Base
  get '/api/v1/folders/:id' do
    content_type 'application/json'

    id = params[:id]
    folder = Folder[id]
    files = folder ? Folder[id].simple_files : []

    if folder
      JSON.pretty_generate(data: folder, relationships: files)
    else
      halt 404, "FOLDER NOT FOUND: #{id}"
    end
  end

  post '/api/v1/folders/:folder_id/collaborator/:username' do
    begin
      result = AddCollaboratorForFolder.call(
        account: Account.where(username: params[:username]).first,
        folder: Folder.where(id: params[:folder_id]).first)
      status result ? 201 : 403
    rescue => e
      logger.info "FAILED to add collaborator to folder: #{e.inspect}"
      halt 400
    end
  end
end
