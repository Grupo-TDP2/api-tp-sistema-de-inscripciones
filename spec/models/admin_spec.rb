require 'rails_helper'

describe Admin do
  before { create(:admin) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  context 'when another user tries to use its email' do
    let(:admin) { create(:admin) }
    let(:student) { build(:student, email: admin.email) }

    it 'does not create that user' do
      expect { student.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
