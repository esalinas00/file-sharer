require 'sequel'

Sequel.migration do
  change do
    create_table(:simple_files) do
      String :id, type: :uuid, primary_key: true
      foreign_key :folder_id

      String :filename, null: false
      String :description_encrypted, text: true
      String :document_encrypted, text: true
      String :checksum, unique: true, text: true
      DateTime :created_at
      DateTime :updated_at

      unique [:folder_id, :filename]
    end
  end
end
