class SubjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :credits
  belongs_to :department
end
