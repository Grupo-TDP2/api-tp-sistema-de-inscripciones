class CreateExam < ActiveRecord::Migration[5.1]
  def change
    create_table :exams do |t|
      t.integer :exam_type, null: false, default: 0
      t.belongs_to :final_exam_week, null: false, index: true
      t.belongs_to :course, null: false, index: true
      t.datetime :date_time, null: false
      t.timestamps
    end
  end
end
