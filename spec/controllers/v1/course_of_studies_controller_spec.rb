require 'rails_helper'

describe V1::CourseOfStudiesController do
  describe '#index' do
    let(:index_request) do
      get :index
    end

    context 'when there is no student logged in' do
      it 'returns http status unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a student logged in' do
      let(:current_student) { create(:student) }

      before { sign_in current_student }

      context 'when there are two courses of study' do
        before do
          create(:course_of_study, name: 'Ingeniería Industrial', required_credits: 240)
          create(:course_of_study, name: 'Ingeniería Informática', required_credits: 260)
        end

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
  end
end
