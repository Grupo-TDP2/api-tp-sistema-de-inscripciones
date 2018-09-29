class EnrolmentSerializer < ActiveModel::Serializer
  attributes :id, :type, :created_at
  belongs_to :student
  belongs_to :course
end
