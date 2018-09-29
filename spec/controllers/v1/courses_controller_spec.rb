require 'rails_helper'

describe V1::CoursesController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:test_subject) { course_of_study_subject.subject }
    let(:index_request) do
      get :index, params: { course_of_study_id: course_of_study_subject.course_of_study.id,
                            subject_id: test_subject.id }
    end

    context 'when the subject contains two courses' do
      let!(:current_term) do
        create(:school_term, year: '2018', term: :second_semester, date_start: '2018-08-01',
                             date_end: '2018-12-01')
      end
      let(:course_1) do
        create(:course, name: '001', school_term: current_term, subject: test_subject)
      end

      before do
        create(:lesson_schedule, course: course_1)
        create(:course, name: '002', school_term: current_term, subject: test_subject)
      end

      it 'returns http status ok' do
        index_request
        expect(response).to have_http_status :ok
      end

      it 'returns the right keys' do
        index_request
        expect(response_body.first.keys)
          .to match_array(%w[id name vacancies subject lesson_schedules])
      end

      context 'with courses from other school terms' do
        let(:past_term) do
          create(:school_term, year: '2018', term: :first_semester, date_start: '2018-03-01',
                               date_end: '2018-07-01')
        end

        before { create(:course, name: '003', school_term: past_term, subject: test_subject) }

        it 'only returns two courses' do
          index_request
          expect(response_body.size).to eq 2
        end
      end
    end
  end
end
