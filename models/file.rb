require 'json'
require 'base64'
require 'sequel'

# Holds a full file file's information
class SimpleFile < Sequel::Model
  include SecureModel
  many_to_one :users
  set_allowed_columns :filename, :description, :file_extension, :remark

  def document=(doc_plaintext)
    self.document_encrypted = encrypt(doc_plaintext) if doc_plaintext
  end

  def document
    decrypt(document_encrypted)
  end

  def description=(desc_plaintext)
    self.description_encrypted = encrypt(desc_plaintext) if desc_plaintext
  end

  def description
    decrypt(description_encrypted)
  end

  def to_json(options = {})
    doc = document ? Base64.strict_encode64(document) : nil
    JSON({  type: 'file',
            id: id,
            data: {
              file_name: filename,
              description: description,
              file_extension: file_extension,
              remark: remark,
              base64_document: doc
            }
          },
         options)
  end
end
