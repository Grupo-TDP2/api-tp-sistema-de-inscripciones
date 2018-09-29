FactoryBot.define do
  factory :school_term do
    term { Faker::Number.between(0, 2) }
    year { Faker::Date.between(Time.zone.today, 10.years.from_now).year }
    date_start { Faker::Date.between("01-03-#{year}", "20-03-#{year}") }
    date_end { Faker::Date.between("01-07-#{year}", "20-07-#{year}") }
  end
end
