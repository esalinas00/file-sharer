# Sinatra Application Controllers
class FileSharingAPI < Sinatra::Base
  get '/api/v1/accounts/:id/folders/?' do
    content_type 'application/json'

    begin
      id = params[:id]
      halt 401 unless authorized_account?(env, id)
      all_folders = FindAllAccountFolders.call(id: id)
      JSON.pretty_generate(data: all_folders)
    rescue => e
      llogger.info "FAILED to find folders for user: #{e}"
      halt 404
    end
  end
end
