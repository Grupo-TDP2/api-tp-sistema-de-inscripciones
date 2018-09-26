require 'rails_helper'
 describe V1::CoursesOfStudyController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:test_course_of_study) { course_of_study_subject.course_of_study }
    let(:index_request) do
      get :index
    end
     context 'when there are two courses of study' do
       let(:another_course_of_study) { create(:course_of_study, name: 'Ingeniería Informática', required_credits: 260)}

       before { course_of_study_subject.course_of_study << another_course_of_study }

      it 'returns two courses of study' do
        index_request
        expect(response_body.size).to eq 2
      end
       it 'returns http status ok' do
        index_request
        expect(response).to have_http_status :ok
      end
       it 'returns the right keys' do
        index_request
        expect(response_body.first.keys)
          .to match_array(%w[id name required_credits])
      end

      end
    end
