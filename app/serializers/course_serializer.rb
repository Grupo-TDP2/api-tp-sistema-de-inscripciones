class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :vacancies, :accept_free_condition_exam
  attribute :inscribed?, if: :inscribed_student?
  attribute :able_to_enrol?, if: :inscribed_student?
  attribute :enrolment, if: :inscribed_student?
  belongs_to :subject
  belongs_to :school_term
  has_many :teacher_courses
  has_many :students
  has_many :lesson_schedules

  def inscribed_student?
    current_user.class.name == 'Student'
  end

  def able_to_enrol?
    Time.current.between?(object.school_term.date_start - 1.week, object.school_term.date_start)
  end

  def inscribed?
    Enrolment.exists?(course: object.id, student: current_user.id)
  end

  def enrolment
    Enrolment.find_by(course: object.id, student: current_user.id)
  end
end
