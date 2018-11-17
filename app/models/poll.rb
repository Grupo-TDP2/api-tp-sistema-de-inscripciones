class Poll < ApplicationRecord
  validates :rate, :comment, :course_id, :student_id, presence: true
  validates :student_id, uniqueness: { scope: :course_id, case_sensitive: false }
  validates :rate, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                   less_than_or_equal_to: 5 }

  validate :validate_student_with_approved_enrolment, if: %i[student_id course_id]

  belongs_to :course
  belongs_to :student

  private

  def validate_student_with_approved_enrolment
    return if Enrolment.exists?(student_id: student_id, course_id: course_id, status: :approved)
    errors.add(:student_id, 'must have approved the course')
  end
end
