module V1
  class TeachersController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff]) }, only: [:index]
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Teacher]) }, only: [:courses]

    def index
      render json: Teacher.all, status: :ok
    end

    def courses
      render json: courses_from_department(teacher_from_param),
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject', 'school_term',
                       'teacher_courses', 'teacher_courses.teacher',
                       'subject.department'], status: :ok
    end

    private

    def teacher_from_param
      if params[:teacher_id] == 'me'
        current_user
      elsif Teacher.exists?(params[:teacher_id])
        Teacher.find(params[:teacher_id])
      end
    end

    def courses_from_department(teacher)
      if current_user.is_a?(DepartmentStaff)
        teacher.courses.from_department(current_user.department_id).current_school_term
      else
        teacher.courses.current_school_term
      end
    end
  end
end
