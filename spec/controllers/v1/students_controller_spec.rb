require 'rails_helper'

describe V1::StudentsController do
  describe '#approved_subjects' do
    let(:approved_subjects_request) { get :approved_subjects }

    context 'when there is no student logged in' do
      it 'returns http status unauthorized' do
        approved_subjects_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a department staff logged in' do
      let(:student) { create(:student) }

      before { sign_in student }

      it 'returns http status ok' do
        approved_subjects_request
        expect(response).to have_http_status :ok
      end
    end
  end

  describe '#update' do
    let(:update_request) { patch :update, params: { student: { device_token: 'token' } } }
    let(:student) { create(:student) }

    context 'with no student logged in' do
      it 'returns unauthorized' do
        update_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a student logged in' do
      before { sign_in student }

      it 'updates the student' do
        update_request
        expect(student.reload.device_token).to eq 'token'
      end
    end
  end

  describe '#show' do
    let(:show_request) { get :show }
    let(:student) { create(:student) }

    context 'with a student logged in' do
      before { sign_in student }

      it 'shows the student' do
        show_request
        expect(response_body['email']).to eq student.email
      end
    end
  end

  describe '#pending_exam_courses' do
    let(:pending_exam_courses_request) { get :pending_exam_courses }
    let(:student) { create(:student) }

    context 'with no student logged in' do
      it 'returns unauthorized' do
        pending_exam_courses_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with an expired approved course' do
      let(:past_term) { create(:school_term, year: '2017', term: :first_semester) }
      let(:current_term) { create(:school_term, year: '2018', term: :second_semester) }
      let(:course) { create(:course, school_term: current_term) }
      let(:past_course) { create(:course, school_term: past_term) }

      before do
        create(:school_term, year: '2017', term: :second_semester)
        create(:school_term, year: '2018', term: :summer_school)
        create(:school_term, year: '2018', term: :first_semester)
        Timecop.freeze(current_term.date_start - 4.days) do
          create(:enrolment, course: course, status: :approved,
                             partial_qualification: 8, student: student)
        end
        Timecop.freeze(past_term.date_start - 4.days) do
          create(:enrolment, course: past_course, status: :approved,
                             partial_qualification: 8, student: student)
        end
      end

      it 'returns only one course' do
        sign_in student
        pending_exam_courses_request
        expect(response_body.size).to eq 1
      end

      it 'returns the right course' do
        sign_in student
        pending_exam_courses_request
        expect(response_body.first['course']['id']).to eq course.id
      end
    end
  end
end
