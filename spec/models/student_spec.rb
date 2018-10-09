require 'rails_helper'

describe Student do
  before { create(:student) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:personal_document_number) }
  it { is_expected.to validate_presence_of(:school_document_number) }
  it { is_expected.to validate_presence_of(:birthdate) }
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_presence_of(:address) }

  it { is_expected.to validate_numericality_of(:phone_number) }
  it { is_expected.to validate_length_of(:phone_number).is_at_least(8).is_at_most(10) }
  it { is_expected.to validate_numericality_of(:personal_document_number) }
  it { is_expected.to validate_length_of(:personal_document_number).is_equal_to(8) }
  it { is_expected.to validate_numericality_of(:school_document_number) }
  it { is_expected.to validate_length_of(:school_document_number).is_at_least(5).is_at_most(6) }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  context 'when another user tries to use its email' do
    let(:student) { create(:student) }
    let(:teacher) { build(:teacher, email: student.email) }

    it 'does not create that user' do
      expect { teacher.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
