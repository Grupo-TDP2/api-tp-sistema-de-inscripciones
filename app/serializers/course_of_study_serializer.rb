class CourseOfStudySerializer < ActiveModel::Serializer
  attributes :id, :name, :required_credits
end
