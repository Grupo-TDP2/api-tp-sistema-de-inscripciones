require 'rails_helper'

describe V1::FinalExamWeeksController do
  describe '#index' do
    let(:teacher) { create(:teacher) }
    let(:index_request) { get :index }

    context 'when there is no teacher logged in' do
      it 'returns http status unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher logged in' do
      let(:current_teacher) { create(:teacher) }

      before { sign_in current_teacher }

      context 'when there are two weeks' do
        before do
          create_list(:final_exam_week, 2)
        end

        it 'returns two weeks' do
          index_request
          expect(response_body.size).to eq 2
        end

        it 'returns http status ok' do
          index_request
          expect(response).to have_http_status :ok
        end
      end
    end
  end
end
