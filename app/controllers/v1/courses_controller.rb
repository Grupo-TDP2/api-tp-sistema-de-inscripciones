module V1
  class CoursesController < ApplicationController # rubocop:disable Metrics/ClassLength
    serialization_scope :current_user
    before_action -> { authenticate_user!(['DepartmentStaff']) }, only: %i[associate_teacher
                                                                           create show destroy]
    before_action -> { authenticate_user!(['Teacher']) }, only: %i[enrolments update]
    before_action -> { authenticate_user!(['Student']) }, only: [:index]
    before_action -> { authenticate_user!(%w[Student Teacher DepartmentStaff]) }, only: [:exams]

    def index
      render json: subject.courses.current_school_term,
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject', 'teacher_courses',
                       'teacher_courses.teacher'], status: :ok
    end

    def create
      return no_permissions unless subject_from_department?
      course = Course.new(course_params)
      begin
        course.save_with_additional_info(course_additional_params)
        render json: course, status: :created
      rescue ActiveRecord::RecordInvalid => exception
        render json: { errors: exception }, status: :unprocessable_entity
      end
    end

    def show
      return no_permissions unless staff_from_department?
      if course
        render json: course, status: :ok
      else
        render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      return no_permissions unless staff_from_department?
      course = Course.find(params[:id])
      if course.destroy
        head :ok
      else
        render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      return wrong_course_for_teacher unless teacher_course_exist
      if course.update(update_free_condition_params)
        render json: course
      else
        render json: course.errors.full_messages, status: :unprocessable_entity
      end
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

    def exams
      render json: course.exams, include: ['classroom', 'classroom.building', 'final_exam_week',
                                           'course', 'course.teacher_courses.teacher']
    end

    private

    def subject
      @subject ||= Subject.find(params[:subject_id] || params[:course][:subject_id])
    end

    def course
      @course ||= Course.find(params[:course_id].presence || params[:id])
    end

    def staff_from_department?
      @current_user.department == course.subject.department
    end

    def subject_from_department?
      @current_user.department == subject.department
    end

    def teacher_course_exist
      TeacherCourse.exists?(course: course, teacher: @current_user)
    end

    def no_permissions
      render json: { error: 'No se puede modificar un curso de otro departamento' },
             status: :forbidden
    end

    def wrong_course_for_teacher
      render json: { error: 'El docente no se relaciona con el curso seleccionado' },
             status: :unprocessable_entity
    end

    def course_params
      params.permit(:name, :vacancies, :subject_id, :school_term_id)
    end

    def course_additional_params
      params.permit(lesson_schedules: %i[type day hour_start hour_end classroom_id],
                    teacher_courses: %i[teaching_position teacher_id])
    end

    def update_free_condition_params
      params.require(:course).permit(:accept_free_condition_exam)
    end

    def associate_teacher_params
      params.require(:teacher_course).permit(:teacher_id, :teaching_position)
    end
  end
end
