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

  describe '#index' do
    let(:school_term) { create(:school_term) }
    let(:current_admin) { create(:admin) }
    let(:index_request) do
      get :index
    end

    context 'with no admin logged in' do
      it 'returns unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the admin is logged in' do
      before { sign_in current_admin }

      context 'when there is one school term' do
        before do
          create(:school_term, year: '2018', term: :second_semester, date_start: '2018-08-01',
                               date_end: '2018-12-01')
        end
        it 'returns http status ok' do
          index_request
          expect(response).to have_http_status :ok
        end

        it 'returns the right keys' do
          index_request
          expect(response_body.first.keys)
            .to match_array(%w[id term year date_start date_end])
        end
        it 'only returns one school term' do
          index_request
          expect(response_body.size).to eq 1
        end
      end

      context 'when there are two school terms' do
        before do
          create(:school_term, year: '2018', term: :second_semester, date_start: '2018-08-01',
                               date_end: '2018-12-01')
          create(:school_term, year: '2018', term: :first_semester, date_start: '2018-03-01',
                               date_end: '2018-07-01')
        end
        it 'returns http status ok' do
          index_request
          expect(response).to have_http_status :ok
        end

        it 'returns the right keys' do
          index_request
          expect(response_body.first.keys)
            .to match_array(%w[id term year date_start date_end])
        end
        it 'only returns two school term' do
          index_request
          expect(response_body.size).to eq 2
        end
      end
    end
  end
end
