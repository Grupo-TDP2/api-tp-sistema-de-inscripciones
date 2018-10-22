class Exam < ApplicationRecord
  validates :exam_type, :final_exam_week_id, :course_id, :classroom_id, :date_time, presence: true
  validates :final_exam_week_id, uniqueness: { scope: :course_id, case_sensitive: false }
  validate :validate_hour_range, if: :date_time
  validate :validate_right_week, if: %i[date_time final_exam_week]

  belongs_to :course
  belongs_to :final_exam_week
  belongs_to :classroom
  has_many :student_exams, dependent: :destroy
  has_many :students, through: :student_exams

  enum exam_type: { final: 0, partial: 1 }

  private

  def validate_hour_range
    return if date_time.hour >= 8 && date_time.hour < 21
    errors.add(:date_time, 'cannot be in invalid hours')
  end

  def validate_right_week
    exam_week = final_exam_week.date_start_week
    return if date_time.between?(exam_week, exam_week + 6.days)
    errors.add(:date_time, 'cannot be in a different week than the final exam week it belongs')
  end
end
