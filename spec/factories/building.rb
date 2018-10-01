FactoryBot.define do
  factory :building do
    name { Faker::Lorem.characters(50) }
    address { Faker::Address.street_address }
    postal_code { Faker::Address.postcode }
    city { Faker::Address.city }
  end
end
