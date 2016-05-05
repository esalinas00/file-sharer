require 'sequel'
require 'rbnacl/libsodium'
require 'base64'
require 'json'

# Holds a User's information
class Account < Sequel::Model
  plugin :timestamps, update_on_create: true
  set_allowed_columns :username, :email

  one_to_many :owned_folders, class: :Folder, key: :owner_id
  many_to_many :folders,
               join_table: :accounts_folders,
               left_key: :collaborator_id, right_key: :folder_id

  plugin :association_dependencies, owned_folders: :destroy

  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end

  def to_json(options = {})
    JSON({  type: 'account',
            username: username,
            email: email
          },
         options)
  end
end
