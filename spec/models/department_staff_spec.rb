require 'rails_helper'

describe DepartmentStaff do
  before { create(:department_staff) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:department_id) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  context 'when another user tries to use its email' do
    let(:department_staff) { create(:department_staff) }
    let(:student) { build(:student, email: department_staff.email) }

    it 'does not create that user' do
      expect { student.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
