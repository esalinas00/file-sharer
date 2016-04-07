require 'json'

class SimpleFile
  ROOT_DIR = Dir.getwd.freeze
  STORE_DIR = 'db/'.freeze

  attr_accessor :id, :file_extension, :file_name, :description, :remark

  def initialize new_file
    @id = new_file['id'] || new_id
    @file_extension = new_file['extension']
    @file_name = new_file['file_name']
    @description = new_file['description']
    @remark = new_file['remark']
  end

  def new_id
    Base64.urlsafe_encode64(Digest::SHA256.digest(Time.now.to_s))[0..9]
  end

  def to_json(options = {})
    JSON({ id: @id,
           file_extension: @file_extension,
           file_name: @file_name,
           description: @description,
           remark: @remark },
          options)
  end

  def save
    File.open(STORE_DIR + @id, 'w') do |file|
      file.write(to_json)
    end

    true
  rescue
    false
  end

  def self.find(find_id)
    found_file = File.read(STORE_DIR + find_id)
    SimpleFile.new JSON.parse(found_file)
  end

  def self.all
    Dir.glob(STORE_DIR + '*.*').map do |filename|
      filename.match(%r{public\/(.*)})[1]
    end
  end

  def self.setup
    Dir.mkdir(STORE_DIR, 0760) unless Dir.exist? STORE_DIR
  end

  def self.file_exist?(owner, file_name)
    File.exist? ("%s%s/%s" % [STORE_DIR,owner,file_name])
  end

end
