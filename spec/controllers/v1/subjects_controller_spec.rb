require 'rails_helper'

describe V1::SubjectsController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:index_request) do
      get :index, params: { course_of_study_id: course_of_study_subject.course_of_study.id }
    end

    context 'when the course of study contains two subjects' do
      let(:another_department) { create(:department, code: '00') }
      let(:another_subject) { create(:subject, name: 'Another', department: another_department) }

      before { course_of_study_subject.course_of_study.subjects << another_subject }

      it 'returns two subjects' do
        index_request
        expect(response_body.size).to eq 2
      end

      it 'returns http status ok' do
        index_request
        expect(response).to have_http_status :ok
      end

      it 'returns the right keys' do
        index_request
        expect(response_body.first.keys).to match_array(%w[id name code credits department
                                                           courses])
      end
    end
  end
end
