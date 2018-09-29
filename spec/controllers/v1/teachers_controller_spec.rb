require 'rails_helper'

describe V1::TeachersController do
  describe '#index' do
    let(:index_request) { get :index }

    context 'when there are two teachers' do
      before { create_list(:teacher, 2) }

      it 'returns two teachers' do
        index_request
        expect(response_body.size).to eq 2
      end

      it 'returns http status ok' do
        index_request
        expect(response).to have_http_status :ok
      end

      it 'returns the right keys' do
        index_request
        expect(response_body.first.keys).to match_array(%w[id first_name last_name])
      end
    end
  end

  describe '#my_courses' do
    let(:courses_request) { get :my_courses }
    let(:current_teacher) { create(:teacher) }
    let(:another_teacher) { create(:teacher) }

    context 'when there is no teacher signed in' do
      it 'returns unauthorized' do
        courses_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher signed in' do
      before { sign_in current_teacher }

      context 'with 2 courses' do
        before do
          create_list(:teacher_course, 2, teacher: current_teacher)
          create(:teacher_course, teacher: another_teacher)
        end

        it 'returns his 2 courses' do
          courses_request
          expect(response_body.size).to eq 2
        end

        it 'returns the right keys' do
          courses_request
          expect(response_body.first.keys)
            .to match_array(%w[id name vacancies subject school_term teachers students])
        end
      end
    end
  end
end