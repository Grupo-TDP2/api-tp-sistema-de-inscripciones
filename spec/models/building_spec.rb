require 'rails_helper'

describe Building do
  before { create(:building) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:postal_code) }
  it { is_expected.to validate_presence_of(:city) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
