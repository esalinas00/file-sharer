require 'json'
require 'sequel'

# Holds a Folder's information
class Folder < Sequel::Model
  plugin :timestamps, update_on_create: true
  set_allowed_columns :name

  one_to_many :simple_files
  many_to_one :owner, class: :Account
  many_to_many :collaborators,
               class: :Account, join_table: :base_accounts_folders,
               left_key: :folder_id, right_key: :collaborator_id

  plugin :association_dependencies, simple_files: :destroy

  def before_destroy
    DB[:base_accounts_folders].where(folder_id: id).delete
    super
  end

  def folder_url
    SecureDB.decrypt(folder_url_encrypted)
  end

  def folder_url=(folder_url_plaintext)
    self.folder_url_encrypted = SecureDB.encrypt(folder_url_plaintext) if folder_url_plaintext
  end

  def to_json(options = {})
    JSON({  type: 'folder',
            id: id,
            attributes: {
              name: name,
              folder_url: folder_url
            }
          },
         options)
  end
end
