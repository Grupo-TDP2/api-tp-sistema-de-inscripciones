FactoryBot.define do
  factory :lesson_schedule do
    type { Faker::Number.between(0, 1) }
    day { Faker::Number.between(0, 5) }
    hour_start { Faker::Time.between(Time.zone.today, Time.zone.today, :day).strftime('%H:%M') }
    hour_end { Faker::Time.between(Time.zone.today, Time.zone.today, :night).strftime('%H:%M') }
    course { create(:course) }
    classroom { create(:classroom) }
  end
end
