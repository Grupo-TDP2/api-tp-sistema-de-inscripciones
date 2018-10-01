FactoryBot.define do
  factory :department_staff do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    department { create(:department) }
  end
end
