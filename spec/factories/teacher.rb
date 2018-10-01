FactoryBot.define do
  factory :teacher do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    personal_document_number { Faker::Number.number(8) }
    birthdate { Faker::Date.birthday(20, 70) } # Random birthdate (maximum age between 20 and 70)
    phone_number { Faker::Number.number(10) }
    address { Faker::Address.street_address }
  end
end
