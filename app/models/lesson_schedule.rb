class LessonStudy < ApplicationRecord
  belongs_to :course
  belongs_to :classroom
  validates :type, :day, :hour_start, :hour_end, :date_end, presence: true
  validate :validate_start_end

  references :course, index: true, foreign_key: true
  references :classroom, index: true, foreign_key: true

  enum type: { theory: 0, practice: 1 }

  private

  def validate_start_end
    return if hour_start < hour_end
    errors.add(:hour_start, 'cannot be greater than hour end')
  end

end
