class ExamSerializer < ActiveModel::Serializer
  attributes :id, :exam_type, :date_time
  attribute :inscribed?, if: :student?
  attribute :registration, if: :inscribed?
  belongs_to :final_exam_week
  belongs_to :course
  belongs_to :classroom

  def student?
    current_user.is_a? Student
  end

  def inscribed?
    StudentExam.exists?(exam_id: object.id, student: current_user)
  end

  def registration
    StudentExam.find_by(exam_id: object.id, student: current_user)
  end
end
