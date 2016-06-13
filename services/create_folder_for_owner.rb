# Create new folder for an owner
class CreateFolderForOwner
  def self.call(owner_id:, name:, folder_url: nil)
    owner = BaseAccount[owner_id]
    saved_folder = owner.add_owned_folder(name: name)
    saved_folder.folder_url = folder_url if folder_url
    saved_folder.save
  end
end
