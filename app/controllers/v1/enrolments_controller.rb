module V1
  class EnrolmentsController < ApplicationController
    before_action -> { authenticate_user!(['Student']) }, only: %i[destroy]
    before_action -> { authenticate_user!(%w[Student Teacher DepartmentStaff Admin]) },
                  only: %i[create]
    before_action -> { authenticate_user!(%w[Admin Teacher DepartmentStaff]) }, only: [:update]
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Teacher]) }, only: %i[index]

    def index
      return wrong_course_for_teacher unless teacher_course_exist || admin_role?
      render json: course.enrolments, status: :ok
    end

    def create
      return wrong_course_for_teacher unless teacher_course_exist || @current_user.is_a?(Student)
      enrolment = Enrolment.new(course: course, student_id: student_id)
      enrolment_type(enrolment)
      if enrolment.save
        course.decrease_vacancies!
        render json: enrolment, status: :created
      else
        render json: { error: enrolment.errors.full_messages }, status: :unprocessable_entity
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

    def enrolment_create_params
      params.require(:enrolment).permit(:student_id)
    end

    def teacher_course_exist
      teacher_id = @current_user.is_a?(Teacher) ? @current_user.id : params[:teacher_id]
      TeacherCourse.exists?(course: course, teacher_id: teacher_id)
    end

    def student_id
      @current_user.is_a?(Student) ? @current_user.id : enrolment_create_params[:student_id]
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
