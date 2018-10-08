require 'rails_helper'

describe V1::SchoolTermsController do
  describe '#create' do
    let(:school_term) { create(:school_term) }
    let(:current_admin) { create(:admin) }
    let(:school_term_request) do
      post :create, params: { term: school_term.term, year: school_term.year,
                              date_start: school_term.date_start, date_end: school_term.date_end }
    end

    context 'with no admin logged in' do
      it 'returns unauthorized' do
        school_term_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the admin is logged in' do
      before { sign_in current_admin }

      context 'when we create school term' do
        it 'returns http status created' do
          school_term_request
          expect(response).to have_http_status :created
        end

        it 'creates an school term' do
          expect { school_term_request }.to change(SchoolTerm, :count).by(1)
        end
      end
    end
  end
end
