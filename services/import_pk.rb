class ImportPk
  def self.call(account_id:, pk:)
  	account = BaseAccount.where(id: account_id).first
  	account.public_key = pk if pk
    account.save
  end
end