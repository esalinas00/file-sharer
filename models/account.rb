require 'sequel'
require 'rbnacl/libsodium'
require 'base64'
require 'json'

# Holds and persists an account's information
class BaseAccount < Sequel::Model
  plugin :single_table_inheritance, :type
  plugin :timestamps, update_on_create: true
  set_allowed_columns :username, :email

  one_to_many :owned_folders, class: :Folder, key: :owner_id
  many_to_many :folders,
               join_table: :base_accounts_folders,
               left_key: :collaborator_id, right_key: :folder_id

  plugin :association_dependencies, owned_folders: :destroy

  def to_json(options = {})
    JSON({  type: type,
            id: id,
            username: username,
            email: email
          },
         options)
  end

  def pk=(public_key)
    if public_key
      pk_encrypted = SecureDB.encrypt(public_key)
      public_key = pk_encrypted
    end
  end

  def pk?
    if public_key
      pk = SecureDB.decrypt(public_key)
    end
  end
end

# Regular accounts with full credentials
class Account < BaseAccount
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


end

# SSO accounts without passwords
class SsoAccount < BaseAccount
end
