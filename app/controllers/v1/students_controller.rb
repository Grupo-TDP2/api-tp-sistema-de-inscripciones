module V1
  class StudentsController < ApplicationController
    before_action -> { authenticate_user!(%w[Student]) }, only: [:approved_subjects]

    def approved_subjects
      render json: @current_user.approved_subjects
    end
  end
end
