class SchoolTerm < ApplicationRecord
  validates :term, :year, :date_start, :date_end, presence: true
  validates :year, numericality: { only_integer: true, greater_than: 2017, less_than: 2050 }
  validates :term, uniqueness: { scope: :year, case_sensitive: false }
  validate :validate_year_start_end, :validate_start_end, if: %i[date_start date_end]

  enum term: { first_semester: 0, second_semester: 1, summer_school: 2 }

  has_many :courses, dependent: :destroy

  scope :current_school_term, -> { find_by(year: Time.current.year, term: current_term) }

  def self.current_term
    term(Date.current)
  end

  def self.term(date)
    date > Date.new(date.year, 7, 1) ? :second_semester : beginning_of_year(date)
  end

  def self.beginning_of_year(date)
    date > Date.new(date.year, 3, 1) ? :first_semester : :summer_school
  end

  private

  def validate_year_start_end
    return if date_start.year == year && date_end.year == year
    date_start.year != year ? year_error(:date_start) : year_error(:date_end)
  end

  def validate_start_end
    return if date_start < date_end
    errors.add(:date_start, 'cannot be greater than date end')
  end

  def year_error(attribute)
    errors.add(attribute, 'must have the same input year')
  end
end
