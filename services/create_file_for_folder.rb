# Create new file for a folder
class CreateFileForFolder
  def self.call(folder:, filename:, description: nil, document:)
    saved_file = folder.add_simple_file(filename: filename)
    saved_file.description = description if description
    saved_file.document = document
    saved_file.save
  end
end
