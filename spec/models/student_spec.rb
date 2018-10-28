require 'rails_helper'

describe Student do
  before { create(:student) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:school_document_number) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:priority) }

  it do
    is_expected.to validate_numericality_of(:priority).is_greater_than(0)
                                                      .is_less_than_or_equal_to(100)
  end
  it { is_expected.to validate_numericality_of(:school_document_number) }
  it { is_expected.to validate_length_of(:school_document_number).is_at_least(5).is_at_most(6) }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  context 'when another user tries to use its email' do
    let(:teacher) { create(:teacher) }
    let(:student) { build(:student, email: teacher.email) }

    it 'does not create that user' do
      expect { student.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when the student has approved subjects' do
    let(:school_term) do
      SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
        create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
    let(:course_2) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
    let(:course_3) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
    let(:student) { create(:student) }

    before do
      date_start = school_term.date_start
      Timecop.freeze(date_start - 4.days) do
        create(:enrolment, course: course, status: :approved,
                           final_qualification: 8, student: student)
        create(:enrolment, course: course_2, status: :approved,
                           final_qualification: 8, student: student)
        create(:enrolment, course: course_3, status: :approved,
                           final_qualification: 2, student: student)
      end
    end

    it 'returns those approved subjects' do
      expect(student.approved_subjects.size).to eq 2
    end
  end
end
