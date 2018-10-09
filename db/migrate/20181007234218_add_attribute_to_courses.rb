class AddAttributeToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :accept_free_condition_exam, :boolean, null: false, default: false
  end
end
