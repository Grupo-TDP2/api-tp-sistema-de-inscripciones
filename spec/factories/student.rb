FactoryBot.define do
  factory :student do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    personal_document_number { Faker::Number.number(8) }
    school_document_number { Faker::Number.number(5) }
    birthdate { Faker::Date.birthday(18, 40) } # Random birthdate (maximum age between 18 and 40)
    phone_number { Faker::Number.number(10) }
    address { Faker::Address.street_address }
  end
end
