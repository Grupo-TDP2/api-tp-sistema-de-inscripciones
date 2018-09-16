FactoryBot.define do
  factory :department do
    name { Faker::Commerce.department }
    code { Faker::Number.number(2) }
  end
end
