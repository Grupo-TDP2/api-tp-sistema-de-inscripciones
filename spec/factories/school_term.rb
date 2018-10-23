FactoryBot.define do
  factory :school_term do
    term { SchoolTerm.terms.keys.sample.to_sym }
    year { Faker::Date.between(Time.zone.today, 10.years.from_now).year }
    date_start do
      if term == :first_semester
        Faker::Date.between("08-03-#{year}", "21-03-#{year}")
      elsif term == :second_semester
        Faker::Date.between("08-08-#{year}", "21-08-#{year}")
      else
        Faker::Date.between("08-01-#{year}", "06-01-#{year}")
      end
    end
    date_end do
      if term == :first_semester || term == :second_semester
        date_start + 16.weeks
      else
        date_start + 8.weeks
      end
    end
  end
end
