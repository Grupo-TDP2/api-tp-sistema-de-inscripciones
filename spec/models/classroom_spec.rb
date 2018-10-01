require 'rails_helper'

describe Classroom do
  before { create(:classroom) }

  it { is_expected.to validate_presence_of(:floor) }
  it { is_expected.to validate_presence_of(:number) }

  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:floor).case_insensitive }
end
