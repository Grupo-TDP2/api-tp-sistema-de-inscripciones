class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :floor, :number
  belongs_to :building
end
