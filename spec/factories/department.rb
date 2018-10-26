FactoryBot.define do
  factory :department do
    name { Faker::Lorem.characters(10) }
    code do
      random_code = Faker::Number.between(1, 99).to_s.rjust(2, '0')
      while Department.exists?(code: random_code)
        random_code = Faker::Number.between(9, 98).to_s.rjust(2, '0')
      end
      random_code
    end
  end
end
