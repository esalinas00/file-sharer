class ImportPK
  def self.call(account_id:, pk:)
  	account = BaseAccount.where(id: account_id).first
  	account.pk = pk
  	puts 'savin'
  	puts account.public_key
    account.save
  end
end