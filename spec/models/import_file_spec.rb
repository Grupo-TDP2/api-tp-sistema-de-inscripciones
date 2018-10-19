require 'rails_helper'

describe ImportFile do
  it { is_expected.to validate_presence_of(:filename) }
  it { is_expected.to validate_presence_of(:model) }
  it { is_expected.to validate_presence_of(:rows_successfuly_processed) }
  it { is_expected.to validate_presence_of(:rows_unsuccessfuly_processed) }
end
