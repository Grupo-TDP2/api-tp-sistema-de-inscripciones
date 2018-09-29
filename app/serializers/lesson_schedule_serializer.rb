class LessonScheduleSerializer < ActiveModel::Serializer
  attributes :id, :type, :day, :hour_start, :hour_end
  belongs_to :classroom
end
