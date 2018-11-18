module V1
  class ExamsController < ApplicationController
    serialization_scope :current_user
    before_action -> { authenticate_user!(%w[Admin Teacher DepartmentStaff]) }, only: %i[create destroy]
    before_action -> { authenticate_user!(%w[Admin Student Teacher DepartmentStaff]) },
                  only: [:index]

    def index
      render json: course.exams, include: ['classroom', 'classroom.building', 'final_exam_week',
                                           'course', 'course.teacher_courses.teacher']
    end

    def destroy
      return invalid_course unless teacher_course_exist || staff_from_department?
      exam = Exam.find(params[:id])
      if exam.destroy
        head :ok
      else
        head :unprocessable_entity
      end
    end

    def create
      return invalid_course unless teacher_course_exist || staff_from_department?
      exam = Exam.new(exam_params.merge(course_id: course.id))
      if exam.save
        render json: exam, status: :created
      else
        render json: { error: exam.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def invalid_course
      render json: { error: 'El docente/depto no puede modificar un examen que no sea de su curso/depto' },
             status: :unprocessable_entity
    end

    def staff_from_department?
      byebug
      return false unless @current_user.is_a?(DepartmentStaff)
      @current_user.department == course.subject.department
    end

    def course
      @course ||= Course.find(params[:course_id])
    end

    def exam_params
      params.require(:exam).permit(:final_exam_week_id, :classroom_id, :date_time)
    end

    def teacher_course_exist
      return true if @current_user.is_a? Admin
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end
  end
end
