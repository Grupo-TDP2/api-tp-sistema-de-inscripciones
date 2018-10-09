require 'rails_helper'

describe TeacherCourse do
  it { is_expected.to validate_presence_of(:teaching_position) }
  it { is_expected.to validate_presence_of(:teacher_id) }
  it { is_expected.to validate_presence_of(:course_id) }

  context 'when checking for uniqueness of teacher per course' do
    before { create(:teacher_course) }
    it { is_expected.to validate_uniqueness_of(:teacher_id).scoped_to(:course_id) }
  end

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
      is_expected.not_to validate_uniqueness_of(:teaching_position).ignoring_case_sensitivity
                                                                   .scoped_to(:course_id)
    end
  end

  context 'when the teacher has another course for the same subject' do
    let(:teacher) { create(:teacher) }
    let(:subject) { create(:subject) }
    let(:course_1) { create(:course, subject: subject) }
    let(:course_2) { create(:course, subject: subject) }

    before { create(:teacher_course, teacher: teacher, course: course_1) }

    it 'raises error' do
      teacher_course = build(:teacher_course, teacher: teacher, course: course_2)
      expect { teacher_course.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
