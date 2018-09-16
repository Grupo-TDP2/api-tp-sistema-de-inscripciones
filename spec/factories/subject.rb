FactoryBot.define do
  factory :subject do
    name { Faker::Educator.subject }
    code { Faker::Number.number(2) }
    credits { Faker::Number.between(1, 10) }
    department_id { create(:department).id }
  end
end
