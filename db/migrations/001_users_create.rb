require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, unique: true, null: false
      String :email, unique: true
    end
  end
end