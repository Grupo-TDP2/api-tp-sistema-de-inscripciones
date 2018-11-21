class EnrolmentSerializer < ActiveModel::Serializer
  attributes :id, :type, :partial_qualification, :status, :final_qualification, :created_at
  attribute :exam_qualification
  belongs_to :student
  belongs_to :course

  def exam_qualification
    StudentExam.where.not(qualification: nil)
               .where(student_id: object.student.id, exam_id: object.course.exams.map(&:id)).last
  end
end
