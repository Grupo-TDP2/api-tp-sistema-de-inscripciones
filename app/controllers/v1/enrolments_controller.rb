module V1
  class EnrolmentsController < ApplicationController
    before_action -> { authenticate_user!(['Student']) }, only: %i[create destroy]
    before_action -> { authenticate_user!(%w[Admin Teacher DepartmentStaff]) }, only: [:update]
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Teacher]) }, only: %i[index]

    def index
      return wrong_course_for_teacher unless teacher_course_exist || admin_role?
      render json: course.enrolments, status: :ok
    end

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
      return wrong_course_for_teacher unless teacher_course_exist || admin_role? ||
                                             staff_from_department?
      enrolment = Enrolment.find(params[:id])
      if enrolment.update(enrolment_update_params)
        render json: enrolment
      else
        render json: { errors: enrolment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      enrolment = Enrolment.find(params[:id])
      return wrong_enrolment unless enrolment.student == @current_user
      if enrolment.destroy
        head :ok
      else
        render json: { errors: enrolment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def course
      @course ||= Course.find(params[:course_id])
    end

    def admin_role?
      @current_user.is_a?(Admin) || @current_user.is_a?(DepartmentStaff)
    end

    def enrolment_type(enrolment)
      return enrolment.assign_attributes(type: :conditional) if course.without_vacancies?
      enrolment.assign_attributes(type: :normal)
    end

    def staff_from_department?
      return false unless @current_user.is_a?(DepartmentStaff)
      @current_user.department == course.subject.department
    end

    def enrolment_update_params
      params.require(:enrolment).permit(:status, :partial_qualification, :type)
    end

    def teacher_course_exist
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end

    def wrong_course_for_teacher
      render json: { error: 'El docente/depto no se relaciona con el curso seleccionado' },
             status: :unprocessable_entity
    end

    def wrong_enrolment
      render json: { errors: 'Cannot destroy an enrolment from another student' },
             status: :unprocessable_entity
    end
  end
end
