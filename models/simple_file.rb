require 'json'

class SimpleFile
  ROOT_DIR = Dir.getwd.freeze
  DB_DIR = 'db/'

  attr_accessor :description
  attr_reader :id, :owner, :file_name, :document

  def initialize new_file
    @id = new_file['id'] || new_id
    @owner = new_file['owner']
    @file_name = new_file['file_name']
    @description = new_file['description']
    @document = new_file['document']
  end

  def new_id
    Base64.urlsafe_encode64(Digest::SHA256.digest(Time.now.to_s))[0..9]
  end

  def to_json
    JSON({id: @id,
          owner: @owner,
          file_name: @file_name,
          description: @description,
          document: @document})
  end

  def save
    File.open(STORE_DIR + @owner + '/'+ file_name, 'w') do |file|
      file.write(to_json)
    end
   true
  rescue
    false
  end

  def self.setup
    Dir.mkdir(DB_DIR, 0760) unless Dir.exist? DB_DIR
  end

  def self.file_exist?(owner, file_name)
    File.exist? ("%s%s/%s" % [DB_DIR,owner,file_name])
  end

  def self.find(owner, file_name)
    file = File.read("%s%s/%s" % [DB_DIR,owner,file_name])
    SimpleFile.new JSON.parse(file)
  end
  
  def self.copy
  end

  def self.move
  end
end
