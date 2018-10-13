require 'rails_helper'

describe V1::TeachersController do
  describe '#index' do
    let(:index_request) { get :index }

    context 'when there is no department staff logged in' do
      it 'returns http status unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a department staff logged in' do
      let(:current_staff) { create(:department_staff) }

      before { sign_in current_staff }

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
      let(:date_start) { Date.new(2018, 8, 1) }
      let!(:current_term) do
        create(:school_term, year: '2018', term: :second_semester, date_start: date_start,
                             date_end: date_start + 16.weeks)
      end
      let(:department) { create(:department) }
      let(:subject_1) { create(:subject, department: department) }
      let(:subject_2) { create(:subject, department: department) }
      let(:course_1) do
        create(:course, school_term: current_term, name: '00', subject: subject_1)
      end
      let(:course_2) do
        create(:course, school_term: current_term, name: '01', subject: subject_2)
      end
      let(:course_3) do
        create(:course, school_term: current_term, name: '02', subject: subject_1)
      end

      before { sign_in current_teacher }

      context 'with 2 courses' do
        before do
          create(:teacher_course, teacher: current_teacher, course: course_1)
          create(:teacher_course, teacher: current_teacher, course: course_2)
          create(:teacher_course, teacher: another_teacher, course: course_3)
        end

        it 'returns his 2 courses' do
          courses_request
          expect(response_body.size).to eq 2
        end

        it 'returns the right keys' do
          courses_request
          expect(response_body.first.keys)
            .to match_array(%w[id name lesson_schedules vacancies subject school_term
                               teacher_courses])
        end
      end
    end
  end
end
