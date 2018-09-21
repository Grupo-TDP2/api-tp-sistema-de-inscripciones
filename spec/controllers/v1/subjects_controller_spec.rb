require 'rails_helper'

describe V1::SubjectsController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:index_request) do
      get :index, params: { course_of_study_id: course_of_study_subject.course_of_study.id }
    end

    context 'when the course of study contains two subjects' do
      let(:another_subject) { create(:subject) }

      before { course_of_study_subject.course_of_study.subjects << another_subject }

      it 'returns two subjects' do
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
