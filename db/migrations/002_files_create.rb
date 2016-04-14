require 'sequel'

Sequel.migration do
  change do
    create_table(:files) do
      primary_key :id
      foreign_key :user_id

      String :filename, null: false
      String :description
      String :base64_document, null: false, default: ''
      String :file_extension, null: false, default: ''
      String :remark, null: false, default: 'None'

      unique [:user_id, :filename]
    end
  end
end
