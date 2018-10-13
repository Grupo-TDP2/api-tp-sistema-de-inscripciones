class SchoolTerm < ApplicationRecord
  validates :term, :year, :date_start, :date_end, presence: true
  validates :year, numericality: { only_integer: true, greater_than: 2017, less_than: 2050 }
  validates :term, uniqueness: { scope: :year, case_sensitive: false }
  validate :validate_year_start_end, :validate_start_end, if: %i[date_start date_end]
  validate :validate_semester_length, if: %i[date_start date_end term]
  validate :validate_start_month, if: :date_start

  enum term: { first_semester: 0, second_semester: 1, summer_school: 2 }

  has_many :courses, dependent: :destroy

  scope :current_school_term, -> { find_by(year: Time.current.year, term: current_term) }

  REGULAR_SEMESTER_WEEKS = 16
  SHORT_SEMESTER_WEEKS = 8
  ONE_WEEK = 7
  MARCH = 3
  AUGUST = 8
  JANUARY = 1

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

  def validate_semester_length
    if (first_semester? || second_semester?) && !right_length?(REGULAR_SEMESTER_WEEKS)
      errors.add(:date_start, 'The semester must have 16 weeks.')
    elsif summer_school? && !right_length?(SHORT_SEMESTER_WEEKS)
      errors.add(:date_start, 'The semester must have 8 weeks.')
    end
  end

  def validate_start_month
    if first_semester?
      validate_month(MARCH)
    elsif second_semester?
      validate_month(AUGUST)
    elsif summer_school?
      validate_month(JANUARY)
    end
  end

  def validate_month(month)
    errors.add(:date_start, "The semester must begin in month #{month}.") unless
      expected_month?(month)
  end

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

  def right_length?(expected_weeks)
    length_weeks = ((date_end - date_start) / ONE_WEEK).to_i
    length_weeks == expected_weeks
  end

  def expected_month?(month)
    date_start.month == month
  end
end
