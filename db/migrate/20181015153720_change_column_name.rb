class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    add_column :enrolments, :partial_qualification, :integer
  end
end
