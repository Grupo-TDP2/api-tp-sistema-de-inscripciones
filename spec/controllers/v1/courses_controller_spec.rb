require 'rails_helper'

describe V1::CoursesController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:test_subject) { course_of_study_subject.subject }
    let(:current_student) { create(:student) }
    let(:index_request) do
      get :index, params: { course_of_study_id: course_of_study_subject.course_of_study.id,
                            subject_id: test_subject.id }
    end

    context 'when the subject contains two courses' do
      let!(:current_term) do
        create(:school_term, year: '2018', term: :second_semester)
      end
      let(:course_1) do
        create(:course, name: '001', school_term: current_term, subject: test_subject)
      end

      before do
        create(:lesson_schedule, course: course_1)
        create(:course, name: '002', school_term: current_term, subject: test_subject)
        sign_in current_student
      end

      it 'returns http status ok' do
        index_request
        expect(response).to have_http_status :ok
      end

      it 'returns the right keys' do
        index_request
        expect(response_body.first.keys)
          .to match_array(%w[id name vacancies inscribed? subject lesson_schedules able_to_enrol?
                             teacher_courses accept_free_condition_exam enrolment])
      end

      context 'with courses from other school terms' do
        let(:past_term) do
          create(:school_term, year: '2018', term: :first_semester)
        end

        before { create(:course, name: '003', school_term: past_term, subject: test_subject) }

        it 'only returns two courses' do
          index_request
          expect(response_body.size).to eq 2
        end
      end
    end
  end

  describe '#associate_teacher' do
    let(:course) { create(:course) }
    let(:teacher) { create(:teacher) }

    let(:associate_teacher_request) do
      post :associate_teacher, params: {
        subject_id: course.subject.id, course_id: course.id, teacher_course: {
          teacher_id: teacher.id, teaching_position: 'first_assistant'
        }
      }
    end

    context 'when there is no department staff logged in' do
      it 'returns unauthorized' do
        associate_teacher_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a department staff logged in' do
      let(:department_staff) { create(:department_staff) }

      before { sign_in department_staff }

      context 'when the course to modify is not from the same department' do
        it 'returns forbidden' do
          associate_teacher_request
          expect(response).to have_http_status :forbidden
        end
      end

      context 'when the course to modify is from the same department' do
        let(:subject) { create(:subject, department: department_staff.department) }
        let(:course) { create(:course, subject: subject) }

        it 'creates the association' do
          expect { associate_teacher_request }.to change(TeacherCourse, :count).by(1)
        end

        it 'returns created' do
          associate_teacher_request
          expect(response).to have_http_status :created
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
    let(:course_1) { create(:course, school_term: term, accept_free_condition_exam: false) }
    let(:teacher_course) { create(:teacher_course, course: course_1) }
    let(:update_request) do
      patch :update, params: { id: course_1.id, course: { accept_free_condition_exam: true } }
    end

    context 'when no teacher is logged in' do
      it 'returns unauthorized' do
        update_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when a teacher is logged in' do
      before { sign_in teacher_course.teacher }

      it 'changes the free_condition attribute' do
        update_request
        expect(course_1.reload.accept_free_condition_exam).to be true
      end
    end
  end

  describe '#enrolments' do
    let(:date_start) { Date.new(2018, 8, 16) }
    let(:term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:course_1) { create(:course, school_term: term) }
    let(:teacher_course) { create(:teacher_course, course: course_1) }
    let(:enrolments_request) { get :enrolments, params: { course_id: course_1.id } }

    context 'when there is no teacher signed in' do
      it 'returns unauthorized' do
        enrolments_request
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
          enrolments_request
          expect(response_body.size).to eq 2
        end

        it 'returns the right keys' do
          enrolments_request
          expect(response_body.first.keys)
            .to match_array(%w[id type status partial_qualification final_qualification
                               created_at student course])
        end
      end

      context 'when the course does not belong to the teacher' do
        let(:department) { create(:department, code: '99') }
        let(:subject) { create(:subject, department: department) }
        let(:course_2) { create(:course, subject: subject, school_term: term) }
        let(:enrolments_request) { get :enrolments, params: { course_id: course_2.id } }

        it 'returns unprocessable entity' do
          enrolments_request
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe '#exams' do
    let(:date_start) { Date.new(2018, 8, 16) }
    let(:term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:course_1) { create(:course, school_term: term) }
    let(:student) { create(:student) }
    let(:exams_request) { get :exams, params: { course_id: course_1.id } }

    before { create(:exam, course: course_1) }

    context 'when there is no user logged in' do
      it 'returns unauthorized' do
        exams_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a student logged in' do
      before { sign_in student }

      context 'with a course with exams' do
        it 'returns an array with exams' do
          exams_request
          expect(response_body.size).to eq 1
        end

        it 'returns the right keys' do
          exams_request
          expect(response_body.first.keys)
            .to match_array(%w[id exam_type date_time final_exam_week course inscribed? classroom])
        end
      end
    end
  end

  describe '#show' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:current_department) { create(:department_staff) }
    let(:test_subject) do
      create(:subject, name: 'Another', department: current_department.department)
    end
    let(:course_test) { create(:course, subject: test_subject) }
    let(:show_request) do
      get :show, params: { id: course_test.id }
    end

    context 'when there is one course' do
      let!(:current_term) do
        create(:school_term, year: '2018', term: :second_semester)
      end
      let(:course_1) do
        create(:course, name: '001', school_term: current_term, subject: test_subject)
      end

      before do
        create(:lesson_schedule, course: course_1)
        create(:course, name: '002', school_term: current_term, subject: test_subject)
        sign_in current_department
      end

      it 'returns http status ok' do
        show_request
        expect(response).to have_http_status :ok
      end

      it 'returns the right keys' do
        show_request
        expect(response_body.keys)
          .to match_array(%w[id name vacancies school_term students subject lesson_schedules
                             teacher_courses accept_free_condition_exam])
      end
    end
  end

  describe '#create' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:current_department) { create(:department_staff) }
    let(:test_subject) do
      create(:subject, name: 'Another', department: current_department.department)
    end
    let(:another_department) { create(:department) }
    let(:wrong_subject) { create(:subject, name: 'Wrong', department: another_department) }
    let(:school_term) { create(:school_term) }
    let(:create_course_request) do
      post :create, params:  { course: { name: 'Cátedra',
                                         vacancies: 50,
                                         school_term_id: school_term.id,
                                         subject_id: test_subject.id } }
    end
    let(:wrong_create_course_request) do
      post :create, params:  { course: { name: 'Cátedra',
                                         vacancies: 50,
                                         school_term_id: school_term.id,
                                         subject_id: wrong_subject.id } }
    end

    context 'with no dept logged in' do
      it 'returns unauthorized' do
        create_course_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the dept is logged in' do
      before { sign_in current_department }

      context 'when we create course' do
        it 'returns http status created' do
          create_course_request
          expect(response).to have_http_status :created
        end

        it 'creates an course' do
          expect { create_course_request }.to change(Course, :count).by(1)
        end
      end
      context 'when we create a wrong course' do
        it 'returns http status not created' do
          wrong_create_course_request
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not creates an course' do
          expect { wrong_create_course_request }.to change(Course, :count).by(0)
        end
      end
    end
  end

  describe '#destroy' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:current_department) { create(:department_staff) }
    let(:test_subject) do
      create(:subject, name: 'Another', department: current_department.department)
    end
    let(:school_term) { create(:school_term) }
    let(:course_test) { create(:course, subject: test_subject) }

    let(:delete_request) do
      delete :destroy, params: { id: course_test.id }
    end

    context 'with no dept logged in' do
      it 'returns unauthorized' do
        delete_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the department is logged in' do
      before do
        sign_in current_department
        course_test
      end

      context 'when we delete course' do
        it 'returns http status created' do
          delete_request
          expect(response).to have_http_status :ok
        end

        it 'delete a course' do
          expect { delete_request }.to change(Course, :count).by(-1)
        end
      end
    end
  end
end
