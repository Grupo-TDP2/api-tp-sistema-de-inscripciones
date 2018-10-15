FactoryBot.define do
  factory :enrolment do
    type { Faker::Number.between(0, 1) }
    student { create(:student) }
    course { create(:course) }
    partial_qualification { Faker::Number.between(4, 10) }
  end
end
