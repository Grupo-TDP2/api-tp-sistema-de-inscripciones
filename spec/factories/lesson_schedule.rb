FactoryBot.define do
  factory :lesson_schedule do
    type { Faker::Number.between(0, 1) }
    day { Faker::Date.between(Time.zone.today, 10.years.from_now).day }
    hour_start { Faker::Date.between("09:00", "12:00") }
    hour_end { Faker::Date.between("13:00", "15:00") }
  end
end
