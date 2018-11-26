require 'rails_helper'

describe V1::ReportsController do
  describe '#polls' do
    let(:polls_request) { get :polls, params: { department_id: 1, school_term_id: 1 } }

    context 'when there is no admin logged in' do
      it 'returns http status unauthorized' do
        polls_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is an admin logged in' do
      before { sign_in create(:admin) }

      it 'returns http status 200' do
        polls_request
        expect(response).to have_http_status :ok
      end
    end
  end

  describe '#subject_report' do
    let(:subject_enrolments_request) do
      get :subject_enrolments, params: { department_id: 1, school_term_id: 1 }
    end

    context 'when there is no admin logged in' do
      it 'returns http status unauthorized' do
        subject_enrolments_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is an admin logged in' do
      before { sign_in create(:admin) }

      it 'returns http status 200' do
        subject_enrolments_request
        expect(response).to have_http_status :ok
      end
    end
  end
end
