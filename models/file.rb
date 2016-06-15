require 'json'
require 'base64'
require 'sequel'

# Holds a full file file's information
class SimpleFile < Sequel::Model
  plugin :uuid, field: :id

  plugin :timestamps, update_on_create: true
  set_allowed_columns :filename

  many_to_one :folders

  def document=(doc_plaintext)
    self.document_encrypted = SecureDB.encrypt(doc_plaintext) if doc_plaintext
  end

  def document
    SecureDB.decrypt(document_encrypted)
  end

  def description=(desc_plaintext)
    self.description_encrypted = SecureDB.encrypt(desc_plaintext) if desc_plaintext
  end

  def description
    SecureDB.decrypt(description_encrypted)
  end

  def to_json(options = {})
    doc = document ? Base64.strict_encode64(document) : nil
    JSON({  type: 'file',
            id: id,
            data: {
              filename: filename,
              description: description,
              checksum: checksum,
              document_base64: doc,
              document: document
            }
          },
         options)
  end
end
