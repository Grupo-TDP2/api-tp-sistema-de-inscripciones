FactoryBot.define do
  factory :course_of_study_subject do
    subject_id { create(:subject).id }
    course_of_study_id { create(:course_of_study).id }
  end
end
