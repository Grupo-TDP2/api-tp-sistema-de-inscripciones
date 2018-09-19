class CreateLessonSchedule < ActiveRecord::Migration[5.1]
  def change
    create_table :lesson_schedules do |t|
      t.integer :type, null: false
      t.date :day, null: false
      t.time :hour_start, null: false
      t.time :hour_end, null: false
      t.references :course, index: true, foreign_key: true
      t.references :classroom, index: true, foreign_key: true
      t.timestamps
    end
  end
end
