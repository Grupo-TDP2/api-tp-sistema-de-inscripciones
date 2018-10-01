class SubjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :credits
  belongs_to :department
  has_many :courses
end
