class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :vacancies
  belongs_to :subject
  belongs_to :school_term
  has_many :teacher_courses
  has_many :students
  has_many :lesson_schedules
end
