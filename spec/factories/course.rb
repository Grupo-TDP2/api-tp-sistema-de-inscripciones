FactoryBot.define do
  factory :course do
    name { Faker::Number.between(1, 999) }
    vacancies { Faker::Number.between(1, 50) }
    school_term { create(:school_term) }
    subject { create(:subject) }
  end
end
