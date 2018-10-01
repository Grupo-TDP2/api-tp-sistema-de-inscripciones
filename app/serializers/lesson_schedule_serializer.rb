class LessonScheduleSerializer < ActiveModel::Serializer
  attributes :id, :type, :day, :hour_start, :hour_end
  belongs_to :classroom

  def day
    I18n.t("activerecord.attributes.lesson_schedule.days.#{object.day}")
  end

  def type
    I18n.t("activerecord.attributes.lesson_schedule.types.#{object.type}")
  end
end
