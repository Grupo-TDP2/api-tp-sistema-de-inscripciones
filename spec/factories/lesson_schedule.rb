FactoryBot.define do
  factory :lesson_schedule do
    type { Faker::Number.between(0, 1) }
    day { Faker::Date.between(Time.zone.today, 10.years.from_now).day }
    hour_start { Faker::Time.between(Date.today, Date.today, :day) }
    hour_end { Faker::Time.between(Date.today, Date.today, :night) }
    course { create(:course) }
    classroom { create(:classroom) }
  end
end
