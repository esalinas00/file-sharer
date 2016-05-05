# Add a collaborator to another owner's existing folder
class AddCollaboratorForFolder
  def self.call(account:, folder:)
    if folder.owner.id != account.id
      account.add_folder(folder)
      true
    else
      false
    end
  end
end
