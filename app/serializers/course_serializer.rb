class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :vacancies, :inscribed
  belongs_to :subject
  belongs_to :school_term
  has_many :teachers
  has_many :students
  has_many :lesson_schedules
end
