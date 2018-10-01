class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :vacancies
  attribute :inscribed?, if: :inscribed_student?
  belongs_to :subject
  belongs_to :school_term
  has_many :teachers
  has_many :students
  has_many :lesson_schedules

  def inscribed_student?
    current_user.class.name == 'Student'
  end

  def inscribed?
    Enrolment.exists?(course: object.id, student: current_user.id)
  end
end
