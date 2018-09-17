require 'rails_helper'

describe Course do
  before { create(:course) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:vacancies) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
