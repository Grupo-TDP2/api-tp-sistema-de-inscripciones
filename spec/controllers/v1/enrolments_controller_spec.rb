require 'rails_helper'

describe V1::EnrolmentsController do
  describe '#create' do
    let(:current_student) { create(:student) }
    let(:course_of_study) { create(:course_of_study) }
    let(:enrolment_request) do
      post :create, params: { course_of_study_id: course_of_study.id,
                              subject_id: course.subject.id, course_id: course.id }
    end

    before { course_of_study.subjects << course.subject }

    context 'with no student logged in' do
      let(:course) { create(:course, vacancies: 1) }

      it 'returns unauthorized' do
        enrolment_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the student is logged in' do
      let(:date_start) { Date.new(2018, 8, 16) }
      let(:term) do
        create(:school_term, year: Date.current.year, date_start: date_start,
                             term: SchoolTerm.current_term)
      end

      before do
        Timecop.freeze(date_start - 4.days)
        sign_in current_student
      end

      context 'when the course has one vacancy' do
        let(:course) { create(:course, vacancies: 1, school_term: term) }

        it 'returns http status created' do
          enrolment_request
          expect(response).to have_http_status :created
        end

        it 'creates an enrolment' do
          expect { enrolment_request }.to change(Enrolment, :count).by(1)
        end

        it 'decreases the number of the course vacancies' do
          expect { enrolment_request }.to(change { course.reload.vacancies })
        end

        it 'sets the enrolment as normal' do
          enrolment_request
          expect(response_body['type']).to eq 'normal'
        end
      end

      context 'when the course has zero vacancies' do
        let(:course) { create(:course, vacancies: 0, school_term: term) }

        it 'creates an enrolment' do
          expect { enrolment_request }.to change(Enrolment, :count).by(1)
        end

        it 'does not decrese the course vacancies' do
          expect { enrolment_request }.not_to(change { course.reload.vacancies })
        end

        it 'sets the enrolment as conditional' do
          enrolment_request
          expect(response_body['type']).to eq 'conditional'
        end
      end
    end
  end

  describe '#update' do
    let(:date_start) { Date.new(2018, 8, 16) }
    let(:term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:course_1) { create(:course, school_term: term) }
    let(:teacher_course) { create(:teacher_course, course: course_1) }
    let(:enrolment) do
      Timecop.freeze(date_start - 4.days) do
        create(:enrolment, course: course_1, status: :not_evaluated)
      end
    end
    let(:teacher) { teacher_course.teacher }
    let(:enrolment_request) do
      patch :update, params: { course_id: course_1.id, id: enrolment.id,
                               enrolment: { status: :approved, partial_qualification: 8 } }
    end

    context 'when there is no teacher logged in' do
      it 'returns unauthorized' do
        enrolment_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher logged in' do
      before { sign_in teacher }
      it 'updates the enrolment' do
        enrolment_request
        expect(response_body['status']).to eq 'approved'
      end
    end
  end
end
