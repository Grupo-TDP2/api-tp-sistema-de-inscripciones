class CreateCourseOfStudy < ActiveRecord::Migration[5.1]
  def change
    create_table :course_of_studies do |t|
      t.string :name, null: false
      t.integer :required_credits, null: false
      t.timestamps
    end
  end
end
