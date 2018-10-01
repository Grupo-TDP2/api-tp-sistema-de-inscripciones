module V1
  class CoursesController < ApplicationController
    serialization_scope :current_user
    before_action -> { authenticate_user!('DepartmentStaff') }, only: [:associate_teacher]
    before_action -> { authenticate_user!('Teacher') }, only: [:enrolments]
    before_action -> { authenticate_user!('Student') }, only: [:index]

    def index
      render json: subject.courses.current_school_term,
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject'], status: :ok
    end

    def enrolments
      return wrong_course_for_teacher unless teacher_course_exist
      render json: course.enrolments, status: :ok
    end

    def associate_teacher
      return no_permissions unless staff_from_department?
      teacher_course = TeacherCourse.new(associate_teacher_params.merge(course: course))
      if teacher_course.save
        head :created
      else
        render json: { error: teacher_course.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id])
    end

    def course
      @course ||= Course.find(course_students_params[:course_id])
    end

    def staff_from_department?
      @current_user.department == course.subject.department
    end

    def no_permissions
      render json: { error: 'No se puede modificar un curso de otro departamento' },
             status: :forbidden
    end

    def course_students_params
      params.permit(:course_id)
    end

    def associate_teacher_params
      params.require(:teacher_course).permit(:teacher_id, :teaching_position)
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
