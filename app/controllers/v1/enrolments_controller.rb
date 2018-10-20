module V1
  class EnrolmentsController < ApplicationController
    before_action -> { authenticate_user!(['Student']) }, only: [:create]
    before_action -> { authenticate_user!(%w[Admin Teacher]) }, only: [:update]

    def create
      enrolment = Enrolment.new(course: course, student: @current_user)
      enrolment_type(enrolment)
      if enrolment.save
        course.decrease_vacancies!
        render json: enrolment, status: :created
      else
        render json: { error: 'La inscripcion no ha sido creada' }, status: :unprocessable_entity
      end
    end

    def update
      return wrong_course_for_teacher unless teacher_course_exist
      enrolment = Enrolment.find(params[:id])
      if enrolment.update(enrolment_update_params)
        render json: enrolment
      else
        render json: { errors: enrolment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def course
      @course ||= Course.find(params[:course_id])
    end

    def enrolment_type(enrolment)
      return enrolment.assign_attributes(type: :conditional) if course.without_vacancies?
      enrolment.assign_attributes(type: :normal)
    end

    def enrolment_update_params
      params.require(:enrolment).permit(:status, :partial_qualification)
    end

    def teacher_course_exist
      return true if @current_user.is_a? Admin
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end

    def wrong_course_for_teacher
      render json: { error: 'El docente no se relaciona con el curso seleccionado' },
             status: :unprocessable_entity
    end
  end
end
