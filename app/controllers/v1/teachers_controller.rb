module V1
  class TeachersController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff]) }, only: [:index]
    before_action -> { authenticate_user!(['Teacher']) }, only: [:my_courses]
    before_action -> { authenticate_user!(['Admin']) }, only: [:courses]

    def index
      render json: Teacher.all, status: :ok
    end

    def my_courses
      render json: current_user.courses.current_school_term,
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject', 'school_term',
                       'teacher_courses', 'teacher_courses.teacher',
                       'subject.department'], status: :ok
    end

    def courses
      render json: Teacher.find(params[:teacher_id]).courses.current_school_term,
             include: ['lesson_schedules', 'lesson_schedules.classroom',
                       'lesson_schedules.classroom.building', 'subject', 'school_term',
                       'teacher_courses', 'teacher_courses.teacher',
                       'subject.department'], status: :ok
    end
  end
end
