class AddAtributesToEnrolments < ActiveRecord::Migration[5.1]
  def change
    add_column :enrolments, :status, :integer, null: false, default: 0
    add_column :enrolments, :final_qualification, :integer
  end
end
