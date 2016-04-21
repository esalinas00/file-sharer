require 'json'
require 'sequel'

# Holds a User's information
class User < Sequel::Model
  one_to_many :simple_files
  set_allowed_columns :username, :email
  plugin :association_dependencies, :simple_files => :delete

  def to_json(options = {})
    JSON({  type: 'user',
            id: id,
            attributes: {
              username: username,
              email: email
            }
          },
         options)
  end
end
