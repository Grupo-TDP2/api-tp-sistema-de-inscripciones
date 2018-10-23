class ChangeStudentAttributes < ActiveRecord::Migration[5.1]
  def change
    remove_column :students, :personal_document_number
    remove_column :students, :birthdate
    remove_column :students, :phone_number
    remove_column :students, :address
    add_column :students, :username, :string, null: false
    add_column :students, :priority, :integer, null: false
  end
end
