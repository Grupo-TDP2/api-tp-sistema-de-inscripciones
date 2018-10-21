require 'rails_helper'

describe Admin do
  before { create(:admin) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
