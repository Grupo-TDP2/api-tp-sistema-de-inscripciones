require 'rails_helper'

describe Teacher do
  before { create(:teacher) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:school_document_number) }

  it { is_expected.to validate_numericality_of(:school_document_number) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
