require 'rails_helper'

describe CourseOfStudySubject do
  before { create(:course_of_study_subject) }

  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:course_of_study) }
end
