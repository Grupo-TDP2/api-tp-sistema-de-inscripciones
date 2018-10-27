require 'rails_helper'

describe V1::StudentsController do
  describe '#approved_subjects' do
    let(:approved_subjects_request) { get :approved_subjects }

    context 'when there is no student logged in' do
      it 'returns http status unauthorized' do
        approved_subjects_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a department staff logged in' do
      let(:student) { create(:student) }

      before { sign_in student }

      it 'returns http status ok' do
        approved_subjects_request
        expect(response).to have_http_status :ok
      end
    end
  end
end
