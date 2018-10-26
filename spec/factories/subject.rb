FactoryBot.define do
  factory :subject do
    name { Faker::Lorem.characters(10) }
    code do
      random_code = Faker::Number.between(9, 98).to_s.rjust(2, '0')
      while Subject.exists?(code: random_code)
        random_code = Faker::Number.between(9, 98).to_s.rjust(2, '0')
      end
      random_code
    end
    credits { Faker::Number.between(1, 10) }
    department { create(:department) }
  end
end
