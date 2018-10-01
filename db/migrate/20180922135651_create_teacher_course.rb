class CreateTeacherCourse < ActiveRecord::Migration[5.1]
  def change
    create_table :teacher_courses do |t|
      t.integer :teaching_position, null: false
      t.belongs_to :teacher, index: true
      t.belongs_to :course, index: true
      t.timestamps
    end
  end
end
