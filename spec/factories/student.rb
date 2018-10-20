FactoryBot.define do
  factory :student do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    school_document_number { Faker::Number.number(5) }
    username { "#{first_name.downcase}.#{last_name.downcase}" }
    priority { Faker::Number.number(2) }
  end
end
