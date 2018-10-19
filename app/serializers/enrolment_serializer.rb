class EnrolmentSerializer < ActiveModel::Serializer
  attributes :id, :type, :partial_qualification, :status, :final_qualification, :created_at
  belongs_to :student
  belongs_to :course
end
