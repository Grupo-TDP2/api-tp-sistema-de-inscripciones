class RemoveUnusedColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :teachers, :personal_document_number
    remove_column :teachers, :birthdate
    remove_column :teachers, :phone_number
    remove_column :teachers, :address
    add_column :teachers, :username, :string, null: false
  end
end
