FactoryBot.define do
  factory :classroom do
    floor { Faker::Number.number(1) }
    number { Faker::Number.number(3) }
    building { create(:building) }
  end
end
