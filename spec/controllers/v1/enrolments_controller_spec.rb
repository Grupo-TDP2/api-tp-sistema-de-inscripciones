require 'rails_helper'

describe V1::EnrolmentsController do
  describe '#index' do
    let(:date_start) { Date.new(2018, 8, 16) }
    let(:term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:department_1) { create(:department, code: '10') }
    let(:subject_1) { create(:subject, department: department_1) }
    let(:course_1) { create(:course, school_term: term, subject: subject_1) }
    let(:teacher_course) { create(:teacher_course, course: course_1) }
    let(:index_request) do
      get :index, params: { course_id: course_1.id, teacher_id: teacher_course.id }
    end

    context 'when there is no teacher signed in' do
      it 'returns unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher logged in' do
      before do
        Timecop.freeze(date_start - 4.days)
        sign_in teacher_course.teacher
      end

      context 'when the course has two enrolments' do
        before { create_list(:enrolment, 2, course: teacher_course.course) }

        it 'returns two enrolments' do
          index_request
          expect(response_body.size).to eq 2
        end

        it 'returns the right keys' do
          index_request
          expect(response_body.first.keys)
            .to match_array(%w[id type status partial_qualification final_qualification
                               created_at student course])
        end
      end

      context 'when the course does not belong to the teacher' do
        let(:department) { create(:department, code: '99') }
        let(:subject) { create(:subject, department: department) }
        let(:course_2) { create(:course, subject: subject, school_term: term) }
        let(:index_request) do
          get :index, params: { course_id: course_2.id, teacher_id: teacher_course.id }
        end

        it 'returns unprocessable entity' do
          index_request
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

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
        create(:enrolment, course: course_1, status: :not_evaluated, type: :conditional)
      end
    end
    let(:teacher) { teacher_course.teacher }
    let(:enrolment_request) do
      patch :update, params: { course_id: course_1.id, id: enrolment.id, teacher_id: teacher.id,
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

      context 'when it updates the condition of the enrolment' do
        let(:enrolment_request) do
          patch :update, params: { course_id: course_1.id, id: enrolment.id,
                                   teacher_id: teacher.id, enrolment: { type: :normal } }
        end

        it 'updates the enrolment' do
          enrolment_request
          expect(response_body['type']).to eq 'normal'
        end
      end
    end
  end

  describe '#destroy' do
    let(:school_term) do
      SchoolTerm.find_by(year: Date.current.year, term: SchoolTerm.current_term).presence ||
        create(:school_term, year: Date.current.year, term: SchoolTerm.current_term)
    end
    let(:course) { create(:course, school_term: school_term, accept_free_condition_exam: false) }
    let(:subject) { course.subject }
    let(:student) do
      date_start = course.school_term.date_start
      Timecop.freeze(date_start - 4.days) do
        enrolment = create(:enrolment, course: course, status: :not_evaluated)
        enrolment.student
      end
    end
    let(:enrolment_id) { 10 }
    let(:delete_request) do
      delete :destroy, params: { course_of_study_id: 1, subject_id: subject.id,
                                 course_id: course.id, id: enrolment_id }
    end

    context 'with no student logged in' do
      it 'returns unauthorized' do
        delete_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with a student logged in' do
      let(:enrolment_id) { student.enrolments.last.id }

      before { sign_in student }

      context 'when it is an invalid date for unsubscriptions' do
        it 'returns error' do
          Timecop.freeze(course.school_term.date_start - 1.day) do
            delete_request
            expect(response_body['errors'].last)
              .to match(/deletion must be in the previous week of the start of the school term./)
          end
        end
      end

      context 'when it is a valid date for unsubscriptions' do
        it 'deletes the enrolment' do
          Timecop.freeze(course.school_term.date_start + 1.day) do
            expect { delete_request }.to change(Enrolment, :count).by(-1)
          end
        end
      end
    end

    context 'with a different enrolment' do
      let(:enrolment_id) do
        date_start = course.school_term.date_start
        Timecop.freeze(date_start - 4.days) do
          create(:enrolment, course: course, status: :not_evaluated).id
        end
      end

      before { sign_in student }

      it 'returns error' do
        delete_request
        expect(response_body['errors']).to match(/Cannot destroy an enrolment from another s/)
      end
    end
  end
end
