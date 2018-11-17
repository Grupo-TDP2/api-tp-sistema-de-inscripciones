require 'rails_helper'

describe SubjectReport do
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

  context 'when there are some enrolments' do
    before do
      teacher_course_1 = create(:teacher_course, course: course_1)
      create(:teacher_course, course: course_1)
      create(:teacher_course, course: course_2)
      create(:teacher_course, course: course_2, teacher: teacher_course_1.teacher,
                              teaching_position: :first_assistant)
      create(:teacher_course, course: course_3)
      create(:teacher_course, course: course_4)
      create(:teacher_course, course: course_5)
      build(:enrolment, course: course_1).save(validate: false)
      build(:enrolment, course: course_1).save(validate: false)
      build(:enrolment, course: course_2).save(validate: false)
      build(:enrolment, course: course_3).save(validate: false)
      build(:enrolment, course: course_4).save(validate: false)
      build(:enrolment, course: course_5).save(validate: false)
    end

    it 'returns the subjects from the department' do
      expect(described_class.new(department.id, school_term.id).report.size).to eq 2
    end

    it 'returns all the courses from the subject' do
      expected_courses = [course_1.name, course_2.name]
      expect(described_class.new(department.id, school_term.id).report.first[:courses].all? do |r|
        expected_courses.include?(r[:course])
      end).to eq true
    end

    it 'returns the right number of teachers' do
      expected_number_of_teachers = 3
      expect(described_class.new(department.id, school_term.id).report.first[:teachers])
        .to eq expected_number_of_teachers
    end

    it 'returns the right number of enrolments' do
      expected_number_of_enrolments = 3
      expect(described_class.new(department.id, school_term.id).report.first[:enrolments])
        .to eq expected_number_of_enrolments
    end
  end
end
