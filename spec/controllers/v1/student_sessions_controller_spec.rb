require 'rails_helper'

describe V1::StudentSessionsController do
  describe '#create' do
    let(:create_request) do
      post :create, params: { email: email, password: password }
    end
    let(:student) { create(:student) }

    context 'when input credentials are right' do
      let(:email) { student.email }
      let(:password) { student.password }

      it 'returns the access token' do
        create_request
        expect(response_body['access_token']).not_to be_empty
      end

      it 'returns http status ok' do
        create_request
        expect(response).to have_http_status :ok
      end
    end

    context 'with wrong credentials' do
      let(:email) { student.email }
      let(:password) { "#{student.password} wrong" }

      it 'returns http status unauthorized' do
        create_request
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
