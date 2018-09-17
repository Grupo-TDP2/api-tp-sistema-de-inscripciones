FactoryBot.define do
  factory :course_of_study do
    name { Faker::Educator.degree }
    required_credits { Faker::Number.between(200, 300) }
  end
end
