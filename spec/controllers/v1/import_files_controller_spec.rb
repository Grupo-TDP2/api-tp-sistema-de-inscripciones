require 'rails_helper'

describe V1::ImportFilesController do
  describe '#create' do
    let(:admin) { create(:admin) }
    let(:create_request) do
      post :create, params: { file: 'abc.csv', filename: 'abc.csv', model: model }
    end

    context 'when there is no admin logged in' do
      let(:model) { 'student' }

      it 'returns http status unauthorized' do
        create_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is an admin logged in' do
      before { sign_in admin }

      context 'when there is an invalid model' do
        let(:model) { 'admins' }

        it 'does not create an import file' do
          expect { create_request }.not_to change(ImportFile, :count)
        end

        it 'returns http status unprocessable entity' do
          create_request
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'when there is a valid model' do
        let(:model) { 'student' }

        it 'creates an import file' do
          expect { create_request }.to change(ImportFile, :count).by(1)
        end

        it 'returns http status ok' do
          create_request
          expect(response).to have_http_status :ok
        end
      end
    end
  end
end