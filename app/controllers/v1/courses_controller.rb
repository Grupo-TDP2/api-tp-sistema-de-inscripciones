module V1
  class CoursesController < ApplicationController
    before_action -> { authenticate_user!('Teacher') }, only: [:enrolments]

    def index
      render json: subject.courses.current_school_term, status: :ok
    end

    def enrolments
      return wrong_course_for_teacher unless teacher_course_exist
      render json: course.enrolments, status: :ok
    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id])
    end

    def course
      @course ||= Course.find(course_students_params[:course_id])
    end

    def course_students_params
      params.permit(:course_id)
    end

    def teacher_course_exist
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end

    def wrong_course_for_teacher
      render json: { error: 'El docente no se relaciona con el curso seleccionado' },
             status: :unprocessable_entity
    end
  end
end
