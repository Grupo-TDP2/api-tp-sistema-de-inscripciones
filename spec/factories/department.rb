FactoryBot.define do
  factory :department do
    name { Faker::Commerce.department }
    code { Faker::Number.between(1, 99).to_s.rjust(2, '0') }
  end
end
