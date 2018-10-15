class StudentExamSerializer < ActiveModel::Serializer
  attributes :id, :condition
  belongs_to :student
  belongs_to :exam
end
