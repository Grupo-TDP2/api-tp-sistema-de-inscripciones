class CreateStudentExam < ActiveRecord::Migration[5.1]
  def change
    create_table :student_exams do |t|
      t.belongs_to :exam, null: false, index: true
      t.belongs_to :student, null: false, index: true
      t.integer :qualification
      t.integer :condition, null: false, default: 0
      t.timestamps
    end
  end
end
