require 'rails_helper'

describe V1::ExamsController do
  describe '#destroy' do
    let(:teacher_course) { create(:teacher_course) }
    let!(:exam) { create(:exam, course: teacher_course.course) }
    let(:destroy_request) do
      delete :destroy, params: { course_id: teacher_course.course.id, id: exam.id }
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
          expect{ destroy_request }.to change(Exam, :count).by(-1)
        end
      end
    end

    context 'when logged in with another teacher' do
      let(:current_teacher) { create(:teacher) }

      before { sign_in current_teacher }

      it 'does not delete the exam' do
        expect{ destroy_request }.not_to change(Exam, :count)
      end
    end
  end
end
