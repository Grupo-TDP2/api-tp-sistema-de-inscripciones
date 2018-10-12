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
                             date_end: date_start + 4.months, term: SchoolTerm.current_term)
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
end
