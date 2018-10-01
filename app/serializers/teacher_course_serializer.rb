class TeacherCourseSerializer < ActiveModel::Serializer
  attributes :teaching_position
  belongs_to :teacher
  belongs_to :course
end
