require 'rails_helper'

describe CourseOfStudy do
  before { create(:course_of_study) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:required_credits) }

  it { is_expected.to validate_numericality_of(:required_credits).only_integer }
  it { is_expected.to validate_numericality_of(:required_credits).is_less_than_or_equal_to(300) }
  it { is_expected.to validate_numericality_of(:required_credits).is_greater_than(100) }
end
