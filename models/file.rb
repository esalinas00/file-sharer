require 'json'
require 'base64'
require 'sequel'

# Holds a full configuration file's information
class SimpleFile < Sequel::Model
  many_to_one :users
  set_allowed_columns :filename, :description, :base64_document, :file_extension, :remark

  def to_json(options = {})
    JSON({  type: 'file',
            id: id,
            data: {
              file_name: filename,
              description: description,
              file_extension: file_extension,
              remark: remark,
              base64_document: base64_document
            }
          },
         options)
  end

  def document
    Base64.strict_decode64 base64_document
  end
end

# TODO: implement a more complex primary key?
# def new_id
#   Base64.urlsafe_encode64(Digest::SHA256.digest(Time.now.to_s))[0..9]
# end
