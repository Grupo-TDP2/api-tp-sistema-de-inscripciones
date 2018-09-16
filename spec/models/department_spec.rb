require 'rails_helper'

describe Department do
  before { create(:department) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
end
