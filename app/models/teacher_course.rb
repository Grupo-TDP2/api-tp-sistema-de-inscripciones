class TeacherCourse < ApplicationRecord
  validates :teaching_position, :teacher_id, :course_id, presence: true
  validates :teaching_position, uniqueness: { scope: :course_id, case_sensitive: false },
                                if: :unique_position?
  validates :teacher_id, uniqueness: { scope: :course_id }

  belongs_to :teacher
  belongs_to :course

  enum teaching_position: { course_chief: 0, practice_chief: 1, first_assistant: 2,
                            second_assistant: 3, ad_honorem: 4 }

  private

  def unique_position?
    course_chief? || practice_chief?
  end
end
