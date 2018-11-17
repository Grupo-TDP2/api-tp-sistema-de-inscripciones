class AddAttributeToTeacher < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :school_document_number, :integer
  end
end
