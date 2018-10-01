require 'rails_helper'

describe V1::CoursesController do
  describe '#index' do
    let(:course_of_study_subject) { create(:course_of_study_subject) }
    let(:test_subject) { course_of_study_subject.subject }
    let(:index_request) do
      get :index, params: { course_of_study_id: course_of_study_subject.course_of_study.id,
                            subject_id: test_subject.id }
    end

    context 'when the subject contains two courses' do
      let!(:current_term) do
        create(:school_term, year: '2018', term: :second_semester, date_start: '2018-08-01',
                             date_end: '2018-12-01')
      end
      let(:course_1) do
        create(:course, name: '001', school_term: current_term, subject: test_subject)
      end

      before do
        create(:lesson_schedule, course: course_1)
        create(:course, name: '002', school_term: current_term, subject: test_subject)
      end

      it 'returns http status ok' do
        index_request
        expect(response).to have_http_status :ok
      end

      it 'returns the right keys' do
        index_request
        expect(response_body.first.keys)
          .to match_array(%w[id name vacancies subject lesson_schedules teacher_courses])
      end

      context 'with courses from other school terms' do
        let(:past_term) do
          create(:school_term, year: '2018', term: :first_semester, date_start: '2018-03-01',
                               date_end: '2018-07-01')
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

  describe '#enrolments' do
    let(:teacher_course) { create(:teacher_course) }
    let(:course) { teacher_course.course }
    let(:enrolments_request) { get :enrolments, params: { course_id: course.id } }

    context 'when there is no teacher signed in' do
      it 'returns unauthorized' do
        enrolments_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher logged in' do
      before { sign_in teacher_course.teacher }

      context 'when the course has two enrolments' do
        before { create_list(:enrolment, 2, course: teacher_course.course) }

        it 'returns two enrolments' do
          enrolments_request
          expect(response_body.size).to eq 2
        end

        it 'returns the right keys' do
          enrolments_request
          expect(response_body.first.keys).to match_array(%w[id type created_at student course])
        end
      end

      context 'when the course does not belong to the teacher' do
        let(:department) { create(:department, code: '99') }
        let(:subject) { create(:subject, department: department) }
        let(:course) { create(:course, subject: subject) }

        it 'returns unprocessable entity' do
          enrolments_request
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end
end
