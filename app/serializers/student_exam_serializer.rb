class StudentExamSerializer < ActiveModel::Serializer
  attributes :id, :condition, :qualification
  belongs_to :student
  belongs_to :exam
end
