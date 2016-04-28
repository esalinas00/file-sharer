require 'sequel'

Sequel.migration do
  change do
    create_table(:folders) do
      primary_key :id
      foreign_key :owner_id, :accounts
      String :name, unique: true, null: false
      String :folder_url_encrypted, unique: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
