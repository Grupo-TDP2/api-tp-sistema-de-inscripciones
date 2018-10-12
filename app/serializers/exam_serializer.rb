class ExamSerializer < ActiveModel::Serializer
  attributes :id, :exam_type, :date_time
  belongs_to :final_exam_week
  belongs_to :course
  belongs_to :classroom
end
