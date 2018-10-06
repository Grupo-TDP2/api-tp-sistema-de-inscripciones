require 'rails_helper'

describe Enrolment do
  let(:date_start) { Date.new(2018, 8, 16) }

  context 'when there is a current school term' do
    before do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           date_end: date_start + 4.months, term: SchoolTerm.current_term)
    end

    context 'when trying to enrol with a date lower than 7 days before the next term' do
      before { Timecop.freeze(date_start - 5.days) }

      it 'raises error' do
        enrolment = build(:enrolment)
        expect { enrolment.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when trying to enrol with a date greater than 7 days before the next term' do
      before { Timecop.freeze(date_start - 8.days) }

      it { is_expected.to validate_presence_of(:type) }
      it do
        is_expected.to validate_uniqueness_of(:student_id).ignoring_case_sensitivity
                                                          .scoped_to(:course_id)
      end

      it 'creates the enrolment' do
        enrolment = build(:enrolment)
        expect(enrolment.valid?).to be true
      end

      context 'when the student has another enrolment for the same subject' do
        let(:student) { create(:student) }
        let(:subject) { create(:subject) }
        let(:course_1) { create(:course, subject: subject) }
        let(:course_2) { create(:course, subject: subject) }

        before { create(:enrolment, student: student, course: course_1) }

        it 'raises error' do
          enrolment = build(:enrolment, student: student, course: course_2)
          expect { enrolment.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
