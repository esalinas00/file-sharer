class ImportPK
  def self.call(account_id:, pk:)
  	puts 'QUE PUTA PASA'
  	puts pk
  	account = BaseAccount.where(id: account_id).first
  	account.pk = pk
  	puts 'Encrypted'
  	puts account.public_key
    account.save
  end
end