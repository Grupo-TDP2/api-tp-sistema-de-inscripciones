module V1
  class StudentsController < ApplicationController
    before_action -> { authenticate_user!(%w[Student]) }, only: %i[approved_subjects update show
                                                                   pending_exam_courses]
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Teacher]) },
                  only: %i[index]

    FIREBASE_URL = 'https://fcm.googleapis.com/fcm/send'.freeze

    def index
      render json: Student.all
    end

    def approved_subjects
      render json: @current_user.approved_subjects
    end

    def update
      if @current_user.update(update_params)
        render json: @current_user, status: :ok
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      render json: @current_user
    end

    def pending_exam_courses
      render json: @current_user.pending_exam_courses,
             include: ['course', 'course.school_term', 'course.subject',
                       'course.subject.department', 'course.lesson_schedules', 'course.polls']
    end

    private

    def update_params
      params.require(:student).permit(:device_token, :first_name, :last_name, :email)
    end
  end
end
