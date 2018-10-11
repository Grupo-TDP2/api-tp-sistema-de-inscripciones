FactoryBot.define do
  factory :school_term do
    term { Faker::Number.between(0, 2) }
    year { Faker::Date.between(Time.zone.today, 10.years.from_now).year }
    date_start do
      if term == 0
        Faker::Date.between("01-03-#{year}", "21-03-#{year}")
      elsif term == 1
        Faker::Date.between("01-08-#{year}", "21-08-#{year}")
      else
        Faker::Date.between("01-01-#{year}", "06-01-#{year}")
      end
    end
    date_end do
      if term == 0 || term == 1
        date_start + 16.weeks
      else
        date_start + 8.weeks
      end
    end
  end
end
