class CourseOfStudySubject < ApplicationRecord
  validates :course_of_study, :subject, presence: true
  belongs_to :course_of_study
  belongs_to :subject
end
