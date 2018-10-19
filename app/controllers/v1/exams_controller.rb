module V1
  class ExamsController < ApplicationController
    serialization_scope :current_user
    before_action -> { authenticate_user!(['Teacher']) }, only: %i[create destroy]

    def destroy
      return invalid_course unless teacher_course_exist
      exam = Exam.find(params[:id])
      if exam.delete
        head :ok
      else
        head :unprocessable_entity
      end
    end

    def create
      return invalid_course unless teacher_course_exist
      exam = Exam.new(exam_params.merge(course_id: course.id))
      if exam.save
        render json: exam, status: :created
      else
        render json: { error: exam.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def invalid_course
      render json: { error: 'El docente no puede eliminar un examen que no sea de su curso' },
             status: :unprocessable_entity
    end

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