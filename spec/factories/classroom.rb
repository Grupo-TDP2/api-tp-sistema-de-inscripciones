FactoryBot.define do
  factory :classroom do
    floor { Faker::Number.number(1) }
    number { Faker::Number.number(3) }
    building { create(:building) }
    has_many :lesson_schedules, dependent: :destroy
  end
end
