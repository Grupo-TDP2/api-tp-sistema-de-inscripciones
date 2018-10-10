class SubjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :credits
  belongs_to :department
  has_many :courses do
    @object.courses.current_school_term
  end
end
