class StudentExam < ApplicationRecord
  validates :student, :exam, :condition, presence: true
  validates :student_id, uniqueness: { scope: :exam_id, case_sensitive: false }
  validates :qualification, numericality: { only_integer: true, greater_than_or_equal_to: 2,
                                            less_than_or_equal_to: 10 }, if: :qualification
  validate :validate_able_to_take_the_exam, if: %i[exam student regular?], on: :create
  validate :valid_free_condition, if: :exam

  belongs_to :student
  belongs_to :exam

  enum condition: { regular: 0, free: 1 }

  def self.to_csv(exam)
    CSV.generate(headers: true) do |csv|
      csv << %w[name registration_date condition]
      exam.student_exams.map do |registration|
        student = registration.student
        csv << ["#{student.last_name} #{student.first_name}", registration.created_at,
                registration.condition]
      end
    end
  end

  def qualifications(params)
    StudentExam.transaction do
      update!(qualification: params[:qualification])
      final_qualification(params)
    end
  end

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

  def qualification_error_message
    'Cannot set final_qualification without an exam qualification'
  end

  def final_qualification(params)
    if free?
      free_enrolment(params[:final_qualification])
    else
      regular_enrolment(params[:final_qualification])
    end
  end

  def free_enrolment(final_qualification)
    if Enrolment.exists?(student: student, course: exam.course, type: :free_exam)
      update_existing_free_enrolment(final_qualification)
    else
      Enrolment.create!(student: student, course: exam.course, type: :free_exam,
                        final_qualification: final_qualification,
                        status: :approved)
    end
  end

  def regular_enrolment(final_qualification)
    student.enrolments_from_subject(exam.course.subject.id)
           .first.update!(final_qualification: final_qualification)
  end

  def update_existing_free_enrolment(final_qualification)
    Enrolment.find_by(student: student, course: exam.course, type: :free_exam)
             .update!(final_qualification: final_qualification)
  end
end
