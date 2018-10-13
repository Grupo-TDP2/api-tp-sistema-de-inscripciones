class CreateFinalExamWeek < ActiveRecord::Migration[5.1]
  def change
    create_table :final_exam_weeks do |t|
      t.date :date_start_week, null: false
      t.string :year, null: false, default: Date.current.year
      t.timestamp
    end
  end
end
