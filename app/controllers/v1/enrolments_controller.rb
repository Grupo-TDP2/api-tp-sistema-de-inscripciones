module V1
  class EnrolmentsController < ApplicationController
    before_action -> { authenticate_user!('Student') }

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

    private

    def course
      @course ||= Course.find(params[:course_id])
    end

    def enrolment_type(enrolment)
      return enrolment.assign_attributes(type: :conditional) if course.without_vacancies?
      enrolment.assign_attributes(type: :normal)
    end
  end
end
