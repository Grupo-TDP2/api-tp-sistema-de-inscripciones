module V1
  class DepartmentsController < ApplicationController
    before_action -> { authenticate_user!(['DepartmentStaff']) }, only: [:my_courses]
    before_action -> { authenticate_user!(['Admin']) }, only: %i[index]

    def index
      render json: Department.all
    end

    def my_courses
      render json: @current_user.department.subjects,
             include: ['courses', 'courses.teacher_courses', 'courses.teacher_courses.teacher',
                       'courses.lesson_schedules.classroom',
                       'courses.lesson_schedules.classroom.building', 'subject'], status: :ok
    end
  end
end
