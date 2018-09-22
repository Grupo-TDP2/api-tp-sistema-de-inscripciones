FactoryBot.define do
  factory :teacher_course do
    teaching_position { Faker::Number.between(0, 3) }
    teacher { create(:teacher) }
    course { create(:course) }
  end
end
