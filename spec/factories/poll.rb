FactoryBot.define do
  factory :poll do
    student { create(:student) }
    course { create(:course) }
    rate { Faker::Number.between(0, 5) }
    comment { Faker::Lorem.characters(50) }
  end
end
