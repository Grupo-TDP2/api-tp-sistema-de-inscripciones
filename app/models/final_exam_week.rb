class FinalExamWeek < ApplicationRecord
  validates :date_start_week, :year, presence: true
  validates :date_start_week, uniqueness: { scope: :year, case_sensitive: false }
  validates :year, numericality: { only_integer: true, greater_than: 2017, less_than: 2050 }
  validate :validate_start_week, if: :date_start_week
  validate :validate_week_school_term, if: :date_start_week
  validate :validate_same_year, if: %i[date_start_week year]

  private

  def validate_start_week
    return if date_start_week.strftime('%A') == 'Monday'
    errors.add(:date_start_week, 'must be Monday')
  end

  def validate_week_school_term
    return if date_start_week.month == 7 || date_start_week.month == 8 ||
              date_start_week.month == 12 || date_start_week.month == 2
    errors.add(:date_start_week, 'must be in February, July, August or December')
  end

  def validate_same_year
    return if date_start_week.year.to_s == year
    errors.add(:date_start_week, 'must match the year set')
  end
end
