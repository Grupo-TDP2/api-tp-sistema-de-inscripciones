FactoryBot.define do
  factory :exam do
    final_exam_week { create(:final_exam_week) }
    course { create(:course) }
    date_time do
      day = Faker::Date.between(final_exam_week.date_start_week,
                                final_exam_week.date_start_week + 5.days)
      Time.zone.parse("#{day} 18:00:00")
    end
  end
end
