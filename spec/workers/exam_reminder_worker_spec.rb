require 'rails_helper'

describe ExamReminderWorker do
  describe '#perform' do
    context 'when there is a student with an upcoming exam' do
      let(:school_term) do
        SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
          create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
      end
      let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
      let(:exam) do
        exam = build(:exam, course: course, date_time: 3.days.from_now)
        exam.save(validate: false)
        exam
      end
      let(:student) do
        date_start = exam.course.school_term.date_start
        Timecop.freeze(date_start - 4.days) do
          enrolment = create(:enrolment, course: exam.course, status: :approved,
                                         partial_qualification: 8)
          enrolment.student
        end
      end

      before do
        Timecop.freeze(exam.date_time - 3.days) do
          create(:student_exam, student: student, exam: exam)
        end
      end

      it 'sends the push notification' do
        expect(HTTParty).to receive(:post) # rubocop:disable RSpec/MessageSpies
        described_class.new.perform
      end
    end
  end
end
