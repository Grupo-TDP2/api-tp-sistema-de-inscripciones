require 'rails_helper'

describe Subject do
  before { create(:subject) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:credits) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }

  it { is_expected.to validate_numericality_of(:credits).only_integer }
  it { is_expected.to validate_numericality_of(:credits).is_less_than_or_equal_to(10) }
  it { is_expected.to validate_numericality_of(:credits).is_greater_than(0) }
end
