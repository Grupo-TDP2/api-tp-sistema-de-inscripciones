require 'rails_helper'

describe StudentExam do
  before { create(:student_exam) }

  it { is_expected.to validate_presence_of(:student) }
  it { is_expected.to validate_presence_of(:exam) }
  it { is_expected.to validate_presence_of(:condition) }
  it { is_expected.to validate_uniqueness_of(:student_id).scoped_to(:exam_id).case_insensitive }

  context 'when the student exam is regular' do
    let(:student_exam) { build(:student_exam, student: student, exam: exam, condition: :regular) }

    before { Timecop.freeze(Date.new(2018, 10, 1)) }

    context 'with a course that does not accept free condition' do
      let(:school_term) do
        SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
          create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
      end
      let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
      let(:exam) { create(:exam, course: course) }

      context 'when the student has not approved the course' do
        let(:student) do
          date_start = exam.course.school_term.date_start
          Timecop.freeze(date_start - 4.days) do
            enrolment = create(:enrolment, course: exam.course, status: :not_evaluated,
                                           partial_qualification: 8)
            enrolment.student
          end
        end

        it 'returns the right error' do
          student_exam.save
          expect(student_exam.errors.full_messages.last).to match(
            /has not approved the course/
          )
        end
      end

      context 'when the student has approved the course and has expired' do
        let(:past_term) { create(:school_term, year: '2017', term: :first_semester) }
        let(:old_course) { create(:course, school_term: past_term, subject: exam.course.subject) }
        let(:student) do
          Timecop.freeze(past_term.date_start - 4.days) do
            enrolment = create(:enrolment, course: old_course, status: :approved,
                                           partial_qualification: 8)
            enrolment.student
          end
        end

        before do
          # Current term is second_semester of 2018
          create(:school_term, year: '2018', term: :first_semester)
          create(:school_term, year: '2018', term: :summer_school)
          create(:school_term, year: '2017', term: :second_semester)
        end

        it 'returns the right error' do
          student_exam.save
          expect(student_exam.errors.full_messages.last).to match(
            /has all expirated approvals/
          )
        end
      end

      context 'when the student has expired approvals and non expired approvals' do
        let(:term_2) { create(:school_term, year: '2017', term: :second_semester) }
        let(:course_2) { create(:course, school_term: term_2, subject: exam.course.subject) }
        let(:student) do
          Timecop.freeze(term_2.date_start - 4.days) do
            enrolment = create(:enrolment, course: course_2, status: :approved,
                                           partial_qualification: 8)
            enrolment.student
          end
        end

        before do
          # Current term is second_semester of 2018
          create(:school_term, year: '2018', term: :first_semester)
          create(:school_term, year: '2018', term: :summer_school)
          old_term = create(:school_term, year: '2017', term: :first_semester)
          old_course = create(:course, school_term: old_term, subject: exam.course.subject)
          Timecop.freeze(old_term.date_start - 4.days) do
            create(:enrolment, course: old_course, status: :approved, partial_qualification: 8,
                               student: student)
          end
        end

        it 'creates the instance' do
          expect { student_exam.save }.to change(described_class, :count)
        end
      end

      context 'when the student has approved the course and has not expired' do
        let(:student) do
          date_start = exam.course.school_term.date_start
          Timecop.freeze(date_start - 4.days) do
            enrolment = create(:enrolment, course: exam.course, status: :approved,
                                           partial_qualification: 8)
            enrolment.student
          end
        end

        it 'creates the instance' do
          expect { student_exam.save }.to change(described_class, :count)
        end
      end

      context 'when the student has disapproved the course' do
        let(:student) do
          date_start = exam.course.school_term.date_start
          Timecop.freeze(date_start - 4.days) do
            enrolment = create(:enrolment, course: exam.course, status: :disapproved,
                                           partial_qualification: 8)
            enrolment.student
          end
        end

        it 'returns the right error' do
          student_exam.save
          expect(student_exam.errors.full_messages.last).to match(
            /has taken all chances/
          )
        end
      end
    end
  end

  context 'when the student exam is in free condition' do
    let(:student) { create(:student) }
    let(:student_exam) { build(:student_exam, student: student, exam: exam, condition: :free) }

    context 'with a course that does not accept free condition' do
      let(:school_term) do
        SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term)
      end
      let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
      let(:exam) { create(:exam, course: course) }

      it 'returns the right error' do
        student_exam.save
        expect(student_exam.errors.full_messages.last).to match(
          /free is only allowed for courses that accept that condition/
        )
      end
    end

    context 'with a course that accepts free condition' do
      let(:school_term) do
        SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term)
      end
      let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: true) }
      let(:exam) { create(:exam, course: course) }

      it 'creates the instance' do
        expect { student_exam.save }.to change(described_class, :count)
      end
    end
  end
end
