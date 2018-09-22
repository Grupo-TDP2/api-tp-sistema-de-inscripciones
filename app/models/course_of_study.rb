class CourseOfStudy < ApplicationRecord
  validates :name, :required_credits, presence: true
  validates :required_credits, numericality: { only_integer: true, greater_than: 100,
                                               less_than_or_equal_to: 300 }
<<<<<<< HEAD
  has_many :subjects, dependent: :destroy
  has_many :lesson_schedules, dependent: :destroy
=======
  has_many :course_of_study_subjects, dependent: :destroy
  has_many :subjects, through: :course_of_study_subjects
>>>>>>> 5af19b7fa817c3d3b8d4755f6fc9ca044a43c266
end
