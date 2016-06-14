# Find all folders (owned and contributed to) by an account
class FindAllAccountFolders
  def self.call(id:)
    base_account = BaseAccount.first(id: id)
    base_account.folders + base_account.owned_folders
  end
end
