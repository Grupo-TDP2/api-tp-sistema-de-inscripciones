module V1
  class FinalExamWeeksController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff Teacher Student]) },
                  only: [:index]

    def index
      render json: FinalExamWeek.all.order(date_start_week: :desc).last(6), status: :ok
    end
  end
end
