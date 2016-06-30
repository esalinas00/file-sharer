class FileSharingAPI < Sinatra::Base
  get '/api/v1/folders/:id/files/?' do
    content_type 'application/json'

    folder = Folder[params[:id]]

    JSON.pretty_generate(data: folder.simple_files)
  end

  get '/api/v1/foldersByName/:name/files/?' do
    content_type 'application/json'

    folder = Folder.where(name: params[:name]).first

    JSON.pretty_generate(data: folder.simple_files)
  end

  get '/api/v1/folders/:folder_id/files/:id/?' do
    content_type 'application/json'

    begin
      doc_url = URI.join(@request_url.to_s + '/', 'document')
      file = SimpleFile.where(folder_id: params[:folder_id], id: params[:id])
                       .first
      halt(404, 'Files not found') unless file
      JSON.pretty_generate(data: {
                             file: file,
                             links: { document: doc_url }
                           })
    rescue => e
      status 400
      logger.info "FAILED to process GET file request: #{e.inspect}"
      e.inspect
    end
  end

  get '/api/v1/foldersByName/:folder_name/filesByName/:name/?' do
    content_type 'application/json'

    begin
      doc_url = URI.join(@request_url.to_s + '/', 'document')
      folder_id = Folder.where(name: params[:folder_name]).first.id
      file = SimpleFile.where(folder_id: folder_id, filename: params[:name])
                       .first
      halt(404, 'Files not found') unless file
      JSON.pretty_generate(data: {
                             file: file,
                             links: { document: doc_url }
                           })
    rescue => e
      status 400
      logger.info "FAILED to process GET file request: #{e.inspect}"
      e.inspect
    end
  end

  get '/api/v1/folders/:folder_id/files/:id/document' do
    content_type 'text/plain'

    begin
      SimpleFile.where(folder_id: params[:folder_id], id: params[:id])
                .first
                .document
    rescue => e
      status 404
      e.inspect
    end
  end

  get '/api/v1/foldersByName/:folder_name/filesByName/:name/document' do
    content_type 'text/plain'

    begin
      folder_id = Folder.where(name: params[:folder_name]).first.id
      SimpleFile.where(folder_id: folder_id, filename: params[:name])
                .first
                .document
    rescue => e
      status 404
      e.inspect
    end
  end

  post '/api/v1/folders/:folder_id/files/?' do
    content_type 'application/json'
    # folder = authorized_affiliated_folder(env, params[:folder_id])
    begin
      new_data = JSON.parse(request.body.read)
      folder = Folder[params[:folder_id]]
      saved_file = CreateFileForFolder.call(
        folder: folder,
        filename: new_data['filename'],
        description: new_data['description'],
        document: new_data['document'])
    rescue => e
      logger.info "FAILED to create new file: #{e.inspect}"
      halt 400
    end

    status 201
    saved_file.to_json
  end
end
