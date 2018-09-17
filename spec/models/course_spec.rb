require 'rails_helper'

describe Course do
  before { create(:course) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:vacancies) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it { is_expected.to validate_numericality_of(:vacancies).only_integer }
  it { is_expected.to validate_numericality_of(:vacancies).is_less_than_or_equal_to(50) }
  it { is_expected.to validate_numericality_of(:vacancies).is_greater_than_or_equal_to(0) }
end
