require 'rails_helper'

describe Enrolment do
  before { create(:enrolment) }

  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:valid_enrolment_datetime) }
end
