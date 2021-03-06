require 'rails_helper'

describe V1::ExamsController do
  describe '#index' do
    let(:date_start) { Date.new(2018, 8, 16) }
    let(:term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:course_1) { create(:course, school_term: term) }
    let(:student) { create(:student) }
    let(:index_request) do
      get :index, params: { course_of_study_id: '1',
                            subject_id: course_1.subject.id, course_id: course_1.id }
    end

    before { create(:exam, course: course_1) }

    context 'when there is no user logged in' do
      it 'returns unauthorized' do
        index_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a student logged in' do
      before { sign_in student }

      context 'with a course with exams' do
        it 'returns an array with exams' do
          index_request
          expect(response_body.size).to eq 1
        end

        it 'returns the right keys' do
          index_request
          expect(response_body.first.keys)
            .to match_array(%w[id exam_type date_time final_exam_week course inscribed? classroom])
        end
      end
    end
  end

  describe '#destroy' do
    let(:teacher_course) { create(:teacher_course) }
    let!(:exam) { create(:exam, course: teacher_course.course) }
    let(:destroy_request) do
      delete :destroy, params: { course_id: teacher_course.course.id, id: exam.id,
                                 teacher_id: teacher_course.teacher.id }
    end

    context 'when there is no teacher logged in' do
      it 'returns http status unauthorized' do
        destroy_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher logged in' do
      let(:current_teacher) { teacher_course.teacher }

      before { sign_in current_teacher }

      context 'when there is an exam' do
        it 'deletes the exam' do
          expect { destroy_request }.to change(Exam, :count).by(-1)
        end
      end
    end

    context 'when logged in with another teacher' do
      let(:current_teacher) { create(:teacher) }

      before { sign_in current_teacher }

      it 'does not delete the exam' do
        expect { destroy_request }.not_to change(Exam, :count)
      end
    end
  end

  describe '#create' do
    let(:date_start) { Date.new(2018, 8, 16) }
    let(:term) do
      create(:school_term, year: Date.current.year, date_start: date_start,
                           term: SchoolTerm.current_term)
    end
    let(:course_1) { create(:course, school_term: term) }
    let(:teacher_course) { create(:teacher_course, course: course_1) }
    let(:final_exam_week) { create(:final_exam_week, year: Date.current.year) }
    let(:classroom) { create(:classroom) }
    let(:post_request) do
      post :create, params: {
        course_id: course_1.id, teacher_id: teacher_course.teacher.id,
        exam: { final_exam_week_id: final_exam_week.id, classroom_id: classroom.id,
                date_time: Time.zone.parse(final_exam_week.date_start_week.to_s) + 10.hours }
      }
    end

    context 'when there is no teacher logged in' do
      it 'returns http status unauthorized' do
        post_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when there is a teacher logged in' do
      before { sign_in teacher_course.teacher }

      it 'creates the exam' do
        expect { post_request }.to change(Exam, :count).by 1
      end

      it 'returns http status created' do
        post_request
        expect(response).to have_http_status :created
      end
    end
  end
end
