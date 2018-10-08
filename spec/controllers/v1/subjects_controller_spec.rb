require 'rails_helper'

describe V1::SubjectsController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:index_request) do
      get :index, params: { course_of_study_id: course_of_study_subject.course_of_study.id }
    end

    context 'when there is no student logged in' do
      it 'returns http status unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a student logged in' do
      let(:current_student) { create(:student) }

      before { sign_in current_student }

      context 'when the course of study contains two subjects' do
        let(:another_department) { create(:department, code: '00') }
        let(:another_subject) { create(:subject, name: 'Another', department: another_department) }

        before do
          SchoolTerm.create(term: :second_semester, date_start: '2018-08-16',
                            date_end: '2018-12-12', year: '2018')
          course_of_study_subject.course_of_study.subjects << another_subject
        end

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
end
