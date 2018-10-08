class Enrolment < ApplicationRecord
  self.inheritance_column = :_type_disabled # So that we can use the :type column
  validates :type, presence: true
  validates :student_id, uniqueness: { scope: :course_id, case_sensitive: false }
  validate :valid_enrolment_date
  validate :unique_student_enrolment

  belongs_to :student
  belongs_to :course

  enum type: { normal: 0, conditional: 1 }

  def valid_enrolment_date
    errors.add(:created_at, 'must belong to some school term') if
      SchoolTerm.current_school_term.blank?
    errors.add(:created_at, 'cannot be less than 7 days before the next school term.') if
      SchoolTerm.current_school_term.date_start - 7.days < Time.current
  end

  def unique_student_enrolment
    subject_courses_ids = course&.subject&.courses&.map(&:id)
    student_enrolments = Enrolment.where(student: student)
    errors.add(:student_id, 'cannot be enrolled in more than one course per subject') if
      student_enrolments.any? { |enrolment| subject_courses_ids.include?(enrolment.course_id) }
  end
end
