# Sinatra Application Controllers
class FileSharingAPI < Sinatra::Base
  get '/api/v1/accounts/:username/folders/?' do
    content_type 'application/json'

    begin
      account = Account.where(username: params[:username]).first
      all_folders = FindAllAccountFolders.call(account)
      JSON.pretty_generate(data: all_folders)
    rescue => e
      logger.info "FAILED to find projects for user #{params[:username]}: #{e}"
      halt 404
    end
  end
end
