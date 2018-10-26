FactoryBot.define do
  factory :course do
    name do
      random_name = Faker::Number.between(1, 999)
      random_name = Faker::Number.between(1, 999) while Course.exists?(name: random_name)
      random_name
    end
    vacancies { Faker::Number.between(1, 50) }
    school_term { create(:school_term) }
    subject { create(:subject) }
  end
end
