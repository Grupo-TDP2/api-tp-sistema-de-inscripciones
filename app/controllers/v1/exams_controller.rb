module V1
  class ExamsController < ApplicationController
    before_action -> { authenticate_user!(['Teacher']) }

    def create
      return wrong_course_for_teacher unless teacher_course_exist
      exam = Exam.new(exam_params.merge(course_id: course.id))
      if exam.save
        render json: exam, status: :created
      else
        render json: { error: exam.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def course
      @course ||= Course.find(params[:course_id])
    end

    def exam_params
      params.require(:exam).permit(:final_exam_week_id, :classroom_id, :date_time)
    end

    def teacher_course_exist
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end
  end
end
