FactoryBot.define do
  factory :final_exam_week do
    year { Faker::Date.between(Time.zone.today, 10.years.from_now).year }
    date_start_week do
      used_weeks = FinalExamWeek.where(year: year).map(&:date_start_week)
      ([Date.new(year, 7, 1).next_week, Date.new(year, 8, 1).next_week,
        Date.new(year, 12, 1).next_week, Date.new(year, 2, 1).next_week] - used_weeks).sample
    end
  end
end
