class StudentExamSerializer < ActiveModel::Serializer
  attributes :id, :condition, :qualification
  attribute :approved_course, unless: :student?
  attribute :approved_school_term, unless: :student?
  belongs_to :student
  belongs_to :exam

  def student?
    current_user.is_a? Student
  end

  def approved_course
    subject_id = object.exam.course.subject.id
    subject_enrolments = object.student.enrolments.joins(:course)
                               .where(status: :approved, courses: { subject_id: subject_id })
    subject_enrolments&.last
  end

  def approved_school_term
    subject_id = object.exam.course.subject.id
    subject_enrolments = object.student.enrolments.joins(:course)
                               .where(status: :approved, courses: { subject_id: subject_id })
    subject_enrolments&.last&.course&.school_term
  end
end
