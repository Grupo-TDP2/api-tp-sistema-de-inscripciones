FactoryBot.define do
  factory :subject do
    name { Faker::Lorem.characters(10) }
    code { Faker::Number.between(9, 98).to_s.rjust(2, '0') }
    credits { Faker::Number.between(1, 10) }
    department { create(:department) }
  end
end
