class LessonSchedule < ApplicationRecord
  belongs_to :course
  belongs_to :classroom
  self.inheritance_column = :_type_disabled
  validates :type, :day, :hour_start, :hour_end, presence: true
  validate :validate_start_end, if: %i[hour_start hour_end]

  enum type: { theory: 0, practice: 1 }
  enum day: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5 }

  private

  def validate_start_end
    return if hour_start < hour_end
    errors.add(:hour_start, 'cannot be greater than hour end')
  end
end
