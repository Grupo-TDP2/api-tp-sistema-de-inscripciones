require 'rails_helper'

describe V1::PollsController do
  describe '#index' do
    let(:index_request) { get :index }

    context 'when there is no student logged in' do
      it 'returns http status unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a student logged in' do
      let(:student) { create(:student) }

      before { sign_in student }

      context 'with two polls' do
        before do
          enrolment_1 = build(:enrolment, student: student, status: :approved)
          enrolment_2 = build(:enrolment, student: student, status: :approved)
          enrolment_1.save(validate: false)
          enrolment_2.save(validate: false)
          create(:poll, student: student, course: enrolment_1.course)
          create(:poll, student: student, course: enrolment_2.course)
        end

        it 'returns two polls' do
          index_request
          expect(response_body.size).to eq 2
        end

        it 'returns http status ok' do
          index_request
          expect(response).to have_http_status :ok
        end

        it 'returns the right keys' do
          index_request
          expect(response_body.first.keys)
            .to match_array(%w[id rate comment student_id course_id created_at updated_at])
        end
      end
    end
  end

  describe '#create' do
    let(:course_id) { 1 }
    let(:rate) { 3 }
    let(:comment) { 'test_comment' }
    let(:create_request) do
      post :create, params: { poll: { course_id: course_id, rate: rate, comment: comment } }
    end

    context 'when there is no student logged in' do
      it 'returns http status unauthorized' do
        create_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a student logged in' do
      let(:student) { create(:student) }

      before { sign_in student }

      context 'with an approved course' do
        let(:course_id) do
          enrolment_1 = build(:enrolment, student: student, status: :approved)
          enrolment_1.save(validate: false)
          enrolment_1.course.id
        end

        it 'creates the poll' do
          expect { create_request }.to change(Poll, :count).by 1
        end

        it 'returns created' do
          create_request
          expect(response).to have_http_status :created
        end
      end

      context 'with an unexisting course' do
        it 'returns unprocessable_entitu' do
          create_request
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end
end
