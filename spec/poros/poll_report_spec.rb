require 'rails_helper'

describe PollReport do
  let(:department) { create(:department) }
  let(:school_term) { create(:school_term) }
  let(:another_department) { create(:department) }
  let(:another_school_term) { create(:school_term) }

  let(:subject_1) { create(:subject, department: department) }
  let(:subject_2) { create(:subject, department: department) }
  let(:subject_3) { create(:subject, department: another_department) }

  let(:course_1) { create(:course, subject: subject_1, school_term: school_term) }
  let(:course_2) { create(:course, subject: subject_1, school_term: school_term) }
  let(:course_3) { create(:course, subject: subject_2, school_term: school_term) }
  let(:course_4) { create(:course, subject: subject_2, school_term: another_school_term) }
  let(:course_5) { create(:course, subject: subject_3, school_term: school_term) }

  context 'when there are some polls' do
    before do
      build(:poll, course: course_1).save(validate: false)
      build(:poll, course: course_1).save(validate: false)
      build(:poll, course: course_2).save(validate: false)
      build(:poll, course: course_3).save(validate: false)
      build(:poll, course: course_4).save(validate: false)
      build(:poll, course: course_5).save(validate: false)
    end

    it 'returns the polls from the department and school term requested' do
      expect(described_class.new(department.id, school_term.id).report.size).to eq 3
    end

    it 'returns the right courses' do
      expected_courses = [course_1.name, course_2.name, course_3.name]
      expect(described_class.new(department.id, school_term.id).report.all? do |result|
        expected_courses.include?(result[:course])
      end).to eq true
    end

    it 'returns the right mean rate' do
      expected_rate = Poll.where(course: course_1).sum(:rate) / 2.to_f
      expect(described_class.new(department.id, school_term.id).report.first[:mean_rate])
        .to eq expected_rate
    end
  end
end
