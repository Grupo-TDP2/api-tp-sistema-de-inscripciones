require 'rails_helper'

describe Enrolment do
  before { create(:enrolment) }

  it { is_expected.to validate_presence_of(:type) }
end
