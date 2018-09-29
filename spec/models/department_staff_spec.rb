require 'rails_helper'

describe DepartmentStaff do
  before { create(:department_staff) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:department_id) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
