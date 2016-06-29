class FileSharingAPI < Sinatra::Base

  get '/api/v1/accounts/:id/pk' do
    content_type 'application/json'
    id = params[:id]
    halt 401 unless authorized_account?(env, id)
    account = BaseAccount.where(id: id).first

    if account
      JSON.pretty_generate(account: account.to_json, public_key: account.pk)
    else
      halt 404, "FOLDER NOT FOUND: #{id}"
    end
  end
  
end