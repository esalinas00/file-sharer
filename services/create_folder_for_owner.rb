# Create new folder for an owner
class CreateFolderForOwner
  def self.call(owner_id:, name:, folder_url: nil)
    owner = Account[owner_id]
    saved_folder = account.add_owned_folder(name: name)
    saved_folder.folder_url = folder_url if folder_url
    saved_folder.save
  end
end
