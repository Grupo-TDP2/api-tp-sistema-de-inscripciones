require 'rails_helper'

describe SchoolTermUnsubscribeReminderWorker do
  describe '#perform' do
    context 'when there is a student with a course' do
      let(:school_term) do
        SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
          create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
      end
      let(:course) { create(:course, school_term: school_term) }

      before do
        Timecop.freeze(school_term.date_start - 4.days) do
          create(:enrolment, course: course)
        end
      end

      context 'when the date enables to unsubscribe' do
        before { Timecop.freeze(school_term.date_start) }

        it 'sends the push notification' do
          expect(HTTParty).to receive(:post) # rubocop:disable RSpec/MessageSpies
          described_class.new.perform
        end
      end

      context 'when the date does not enable to unsubscribe' do
        it 'sends the push notification' do
          expect(HTTParty).not_to receive(:post) # rubocop:disable RSpec/MessageSpies
          described_class.new.perform
        end
      end
    end
  end
end
