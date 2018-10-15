FactoryBot.define do
  factory :final_exam_week do
    year { Faker::Date.between(Time.zone.today, 10.years.from_now).year }
    date_start_week do
      [Date.new(year, 7, 1), Date.new(year, 8, 1), Date.new(year, 12, 1),
       Date.new(year, 2, 1)].sample.next_week
    end
  end
end
