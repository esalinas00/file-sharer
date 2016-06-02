# Add a collaborator to another owner's existing folder
class AddCollaboratorForFolder
  def self.call(collaborator_id:, folder_id:)
    collaborator = BaseAccount.where(id: collaborator_id.to_i).first
    folder = Folder.where(id: folder_id.to_i).first
    if folder.owner.id != collaborator.id
      collaborator.add_folder(folder)
      true
    else
      false
    end
  end
end
