# Find all folders (owned and contributed to) by an account
class FindAllAccountFolders
  def self.call(account)
    my_folders = Folder.where(owner_id: account.id).all
    other_folders = Folder.join(:accounts_folders, folder_id: :id)
                          .where(collaborator_id: account.id).all
    my_folders + other_folders
  end
end
