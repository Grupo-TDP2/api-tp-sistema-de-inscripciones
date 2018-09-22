class Course < ApplicationRecord
  validates :name, :vacancies, presence: true
  validates :vacancies, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                        less_than_or_equal_to: 50 }
  validates :name, uniqueness: { case_sensitive: false }

  belongs_to :subject
  belongs_to :school_term
  has_many :enrolments, dependent: :destroy
  has_many :students, through: :enrolments
  has_many :teacher_courses, dependent: :destroy
  has_many :teachers, through: :teacher_courses

  scope :current_school_term, -> { where(school_term_id: SchoolTerm.current_school_term.id) }
end