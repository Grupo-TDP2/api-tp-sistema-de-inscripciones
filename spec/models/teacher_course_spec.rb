require 'rails_helper'

describe TeacherCourse do
  before { create(:teacher_course) }

  it { is_expected.to validate_presence_of(:teaching_position) }
  it { is_expected.to validate_presence_of(:teacher_id) }
  it { is_expected.to validate_presence_of(:course_id) }
  it { is_expected.to validate_uniqueness_of(:teacher_id).scoped_to(:course_id) }

  context 'when selecting unique positions' do
    before { create(:teacher_course, teaching_position: 0) }
    it do
      is_expected.to validate_uniqueness_of(:teaching_position).ignoring_case_sensitivity
                                                               .scoped_to(:course_id)
    end
  end

  context 'when selecting not unique positions' do
    before { create(:teacher_course, teaching_position: 2) }
    it do
      is_expected.not_to validate_uniqueness_of(:teaching_position).scoped_to(:course_id)
    end
  end
end
