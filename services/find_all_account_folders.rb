# Find all folders (owned and contributed to) by an account
class FindAllAccountFolders
  def self.call(id:)
    account = Account.where(id: id).first
    account.folders + account.owned_folders
  end
end
