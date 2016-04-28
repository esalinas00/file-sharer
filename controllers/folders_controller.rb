class FileSharingAPI < Sinatra::Base
  get '/api/v1/folders/:id' do
    content_type 'application/json'

    id = params[:id]
    folder = Folder[id]
    files = folder ? Folder[id].simple_files : []

    if project
      JSON.pretty_generate(data: folder, relationships: files)
    else
      halt 404, "FOLDER NOT FOUND: #{id}"
    end
  end
end
