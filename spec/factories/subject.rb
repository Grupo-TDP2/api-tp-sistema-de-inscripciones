FactoryBot.define do
  factory :subject do
    name { Faker::Job.field }
    code { Faker::Number.between(1, 99).to_s.rjust(2, '0') }
    credits { Faker::Number.between(1, 10) }
    department { create(:department) }
  end
end
