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

  describe '#update' do
    let(:update_request) { patch :update, params: { student: { device_token: 'token' } } }
    let(:student) { create(:student) }

    context 'with no student logged in' do
      it 'returns unauthorized' do
        update_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a student logged in' do
      before { sign_in student }

      it 'updates the student' do
        update_request
        expect(student.reload.device_token).to eq 'token'
      end
    end
  end

  describe '#show' do
    let(:show_request) { get :show }
    let(:student) { create(:student) }

    context 'with a student logged in' do
      before { sign_in student }

      it 'shows the student' do
        show_request
        expect(response_body['email']).to eq student.email
      end
    end
  end
end
