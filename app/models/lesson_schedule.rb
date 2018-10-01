class LessonSchedule < ApplicationRecord
  belongs_to :course
  belongs_to :classroom
  self.inheritance_column = :_type_disabled
  validates :type, :day, :hour_start, :hour_end, presence: true
  validate :validate_start_end, if: %i[hour_start hour_end]

  enum type: { theory: 0, practice: 1 }
  enum day: { Monday: 0, Tuesday: 1, Wednesday: 2, Thursday: 3, Friday: 4, Saturday: 5 }

  private

  def validate_start_end
    return if hour_start < hour_end
    errors.add(:hour_start, 'cannot be greater than hour end')
  end
end
