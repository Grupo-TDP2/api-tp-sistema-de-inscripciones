class TeacherCourse < ApplicationRecord
  validates :teaching_position, :teacher_id, :course_id, presence: true
  validates :teaching_position, uniqueness: { scope: :course_id, case_sensitive: false },
                                if: :unique_position?
  validates :teacher_id, uniqueness: { scope: :course_id }
  validate :unique_course_per_subject

  belongs_to :teacher
  belongs_to :course

  enum teaching_position: { course_chief: 0, practice_chief: 1, first_assistant: 2,
                            second_assistant: 3 }

  private

  def unique_position?
    course_chief? || practice_chief?
  end

  def unique_course_per_subject
    subject_courses_ids = course&.subject&.courses&.map(&:id) || []
    teacher_courses = TeacherCourse.where(teacher: teacher)
    errors.add(:teacher_id, 'cannot have more than one course per subject') if
       teacher_courses.any? { |course| subject_courses_ids.include?(course.course_id) }
  end
end
