FactoryBot.define do
  factory :enrolment do
    type { Faker::Number.between(0, 1) }
    valid_enrolment_datetime { Faker::Date.between(2.months.ago, 1.month.ago) }
    student { create(:student) }
    course { create(:course) }
  end
end
