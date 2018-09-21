class CreateEnrolment < ActiveRecord::Migration[5.1]
  def change
    create_table :enrolments do |t|
      t.integer :type, null: false, default: 0
      t.datetime :valid_enrolment_datetime, null: false
      t.belongs_to :student, index: true
      t.belongs_to :course, index: true
      t.timestamps
    end
  end
end
