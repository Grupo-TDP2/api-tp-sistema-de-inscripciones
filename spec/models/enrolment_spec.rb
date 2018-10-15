require 'rails_helper'

describe Enrolment do
  let(:date_start) { Date.new(2018, 8, 16) }

  context 'when there is a current school term' do
    let!(:school_term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term) }

    context 'when trying to enrol with a date lower than 7 days before the next term' do
      before { Timecop.freeze(date_start - 8.days) }

      it 'raises error' do
        enrolment = build(:enrolment, course: course)
        expect { enrolment.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when trying to enrol after the term has started' do
      before { Timecop.freeze(date_start + 1.day) }

      it 'raises error' do
        enrolment = build(:enrolment, course: course)
        expect { enrolment.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when trying to enrol with a date greater than 7 days before the next term' do
      before { Timecop.freeze(date_start - 4.days) }

      it { is_expected.to validate_presence_of(:type) }
      it do
        is_expected.to validate_uniqueness_of(:student_id).ignoring_case_sensitivity
                                                          .scoped_to(:course_id)
      end

      it 'creates the enrolment' do
        enrolment = build(:enrolment, course: course)
        expect(enrolment.valid?).to be true
      end

      context 'when it is evaluated and has no qualification' do
        it 'cannot be updated' do
          enrolment = build(:enrolment, status: :approved)
          enrolment.save
          expect(enrolment.errors.full_messages.last)
            .to match(/Partial qualification no puede estar en blanco/)
        end
      end

      context 'with a qualification higher than 10' do
        it 'cannot be updated' do
          enrolment = build(:enrolment, partial_qualification: 11)
          enrolment.save
          expect(enrolment.errors.full_messages.last)
            .to match(/Partial qualification debe ser menor que o igual a 10/)
        end
      end

      context 'with a qualification less than 4' do
        it 'cannot be updated' do
          enrolment = build(:enrolment, partial_qualification: 3)
          enrolment.save
          expect(enrolment.errors.full_messages.last)
            .to match(/Partial qualification debe ser mayor que o igual a 4/)
        end
      end

      context 'when the student has another enrolment for the same subject' do
        let(:student) { create(:student) }
        let(:subject) { create(:subject) }
        let(:school_term) do
          SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
            create(:school_term, year: Date.current.year, date_start: date_start,
                                 term: SchoolTerm.current_term)
        end
        let(:course_1) { create(:course, subject: subject, school_term: school_term) }
        let(:course_2) { create(:course, subject: subject, school_term: school_term) }

        before { create(:enrolment, student: student, course: course_1) }

        it 'raises error' do
          enrolment = build(:enrolment, student: student, course: course_2)
          expect { enrolment.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
