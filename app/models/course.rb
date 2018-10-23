class Course < ApplicationRecord
  validates :name, :vacancies, presence: true
  validates :vacancies, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                        less_than_or_equal_to: 50 }
  validates :name, uniqueness: { case_sensitive: false }

  belongs_to :subject
  belongs_to :school_term
  has_many :enrolments, dependent: :destroy
  has_many :students, through: :enrolments
  has_many :lesson_schedules, dependent: :destroy
  has_many :teacher_courses, dependent: :destroy
  has_many :teachers, through: :teacher_courses
  has_many :exams, dependent: :destroy
  scope :current_school_term, -> { where(school_term_id: SchoolTerm.current_school_term.id) }

  def without_vacancies?
    vacancies.zero?
  end

  def decrease_vacancies!
    update(vacancies: vacancies - 1) if vacancies.positive?
  end

  def save_with_additional_info(info_params)
    Course.transaction do
      save!
      info_params[:lesson_schedules].map do |lesson_schedule|
        LessonSchedule.create!(lesson_schedule.merge(course_id: id))
      end
      info_params[:teacher_courses].map do |teacher_course|
        TeacherCourse.create!(teacher_course.merge(course_id: id))
      end
    end
  end
end
