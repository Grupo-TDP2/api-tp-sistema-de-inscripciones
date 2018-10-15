module V1
  class FinalExamWeeksController < ApplicationController
    before_action -> { authenticate_user!(['Teacher']) }, only: [:index]

    def index
      render json: FinalExamWeek.all.order(date_start_week: :desc).last(6), status: :ok
    end
  end
end
