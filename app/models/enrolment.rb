class Enrolment < ApplicationRecord
  self.inheritance_column = :_type_disabled # So that we can use the :type column
  validates :type, presence: true
  validates :partial_qualification, presence: true, if: :evaluated?
  validates :student_id, uniqueness: { scope: :course_id, case_sensitive: false },
                         unless: :free_exam?
  validates :partial_qualification, numericality: { only_integer: true,
                                                    greater_than_or_equal_to: 4,
                                                    less_than_or_equal_to: 10 },
                                    if: :partial_qualification
  validates :final_qualification, numericality: { only_integer: true,
                                                  greater_than_or_equal_to: 2,
                                                  less_than_or_equal_to: 10 },
                                  if: :final_qualification
  validate :valid_enrolment_date, on: :create
  validate :unique_student_enrolment, on: :create
  before_destroy do
    valid_delete_date
    throw(:abort) if errors.present?
  end

  belongs_to :student
  belongs_to :course

  enum type: { normal: 0, conditional: 1, free_exam: 2 }
  enum status: { not_evaluated: 0, approved: 1, disapproved: 2 }

  def valid_enrolment_date
    return if free_exam?
    errors.add(:created_at, 'must belong to some school term') if
      SchoolTerm.current_school_term.blank?
    start_term = SchoolTerm.current_school_term.date_start
    errors.add(:created_at, 'must be in the previous week of the start of the school term.') unless
      Time.current.between?(start_term - 1.week, start_term)
  end

  def unique_student_enrolment
    subject_courses_ids = course&.subject&.courses&.current_school_term&.map(&:id)
    errors.add(:student_id, 'cannot be enrolled in more than one course per subject') if
      current_enrolments.any? { |enrolment| subject_courses_ids.include?(enrolment.course_id) }
  end

  def valid_delete_date
    start_term = SchoolTerm.current_school_term.date_start
    return if Time.current.between?(start_term, start_term + 1.week)
    errors.add(:base, 'The deletion must be in the previous week of the start of the school term.')
  end

  def evaluated?
    approved? && !free_exam?
  end

  def current_enrolments
    Enrolment.joins(:course).where(student: student,
                                   courses: { school_term_id: SchoolTerm.current_school_term.id })
  end
end
