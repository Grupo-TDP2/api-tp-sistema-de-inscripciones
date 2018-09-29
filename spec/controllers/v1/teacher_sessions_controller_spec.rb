require 'rails_helper'

describe V1::TeacherSessionsController do
  describe '#create' do
    let(:create_request) do
      post :create, params: { email: email, password: password }
    end
    let(:teacher) { create(:teacher) }

    context 'when input credentials are right' do
      let(:email) { teacher.email }
      let(:password) { teacher.password }

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
      let(:email) { teacher.email }
      let(:password) { "#{teacher.password} wrong" }

      it 'returns http status unauthorized' do
        create_request
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
