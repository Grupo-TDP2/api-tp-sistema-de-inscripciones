class CreateCourseOfStudySubject < ActiveRecord::Migration[5.1]
  def change
    create_table :course_of_study_subjects do |t|
      t.belongs_to :subject, index: true
      t.belongs_to :course_of_study, index: true
      t.timestamps
    end
  end
end
