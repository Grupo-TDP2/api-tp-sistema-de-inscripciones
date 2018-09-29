FactoryBot.define do
  factory :school_term do
    term { Faker::Number.between(0, 1) }
    year { Faker::Date.between(Time.zone.today, 10.years.from_now).year }
    date_start { Faker::Date.between("01-03-#{year}", "01-08-#{year}") }
    date_end { date_start + 4.months }
  end
end
