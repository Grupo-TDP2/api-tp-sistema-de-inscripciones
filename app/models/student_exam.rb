class StudentExam < ApplicationRecord
  validates :student, :exam, :condition, presence: true
  validates :student_id, uniqueness: { scope: :exam_id, case_sensitive: false }
  validate :validate_able_to_take_the_exam, if: %i[exam student regular?]
  validate :valid_free_condition, if: :exam

  belongs_to :student
  belongs_to :exam

  enum condition: { regular: 0, free: 1 }

  private

  def valid_free_condition
    return if regular? || (free? && exam.course.accept_free_condition_exam)
    errors.add(:condition, 'free is only allowed for courses that accept that condition')
  end

  def validate_able_to_take_the_exam
    return errors.add(:student, 'doesnt have courses for that subject') if
      student_subject_courses.empty?
    return errors.add(:student, 'has taken all chances') if course_disapproved?
    return errors.add(:student, 'has not approved the course') unless course_approved?
    errors.add(:student, 'has all expirated approvals') if expirated_approval?
  end

  def course_disapproved?
    student_subject_courses.all?(&:disapproved?)
  end

  def course_approved?
    student_subject_courses.any?(&:approved?)
  end

  def expirated_approval?
    approved_student_courses.all? do |enrolment|
      approval_term = enrolment.course.school_term
      SchoolTerm.where(date_start: approval_term.date_start..Date.current).size > 4
    end
  end

  def approved_student_courses
    student_subject_courses.select(&:approved?)
  end

  def student_subject_courses
    @student_subject_courses ||= exam.course.subject.courses.map do |course|
      course.enrolments.exists?(student: student) ? course.enrolments.where(student: student) : nil
    end.compact.flatten
  end
end
