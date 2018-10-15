module V1
  class ExamsController < ApplicationController
    before_action -> { authenticate_user!(['Teacher']) }, only: [:destroy]

    def destroy
      return invalid_course unless teacher_course_exist?
      exam = Exam.find(params[:id])
      if exam.delete
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def teacher_course_exist?
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end

    def course
      Course.find(params[:course_id])
    end

    def invalid_course
      render json: { error: 'El docente no puede eliminar un examen que no sea de su curso' },
             status: :unprocessable_entity
    end
  end
end
