FactoryBot.define do
  factory :enrolment do
    type { Faker::Number.between(0, 1) }
    student { create(:student) }
    course { create(:course) }
  end
end
