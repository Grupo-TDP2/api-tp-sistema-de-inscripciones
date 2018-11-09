module V1
  class StudentsController < ApplicationController
    before_action -> { authenticate_user!(%w[Student]) }, only: %i[approved_subjects update show
                                                                   pending_exam_courses]

    FIREBASE_URL = 'https://fcm.googleapis.com/fcm/send'.freeze

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
      server_key = Rails.application.secrets.server_push_key
      message_content = {
        to: @current_user.device_token.to_s, notification: { title: 'Logged in user',
                                                             body: @current_user.email }
      }
      HTTParty.post(FIREBASE_URL, body: message_content.to_json,
                                  headers: { 'Content-Type' => 'application/json',
                                             'Authorization' => "key=#{server_key}" })
      render json: @current_user
    end

    def pending_exam_courses
      render json: @current_user.pending_exam_courses,
             include: ['course', 'course.school_term', 'course.subject',
                       'course.subject.department', 'course.lesson_schedules']
    end

    private

    def update_params
      params.require(:student).permit(:device_token)
    end
  end
end
