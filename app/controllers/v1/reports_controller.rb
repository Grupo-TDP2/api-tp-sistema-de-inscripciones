module V1
  class ReportsController < ApplicationController
    before_action -> { authenticate_user!(%w[Admin DepartmentStaff]) }

    def polls
      render json:
        PollReport.new(report_params[:department_id], report_params[:school_term_id]).report
    end

    def subject_enrolments
      render json:
        SubjectReport.new(report_params[:department_id], report_params[:school_term_id]).report
    end

    private

    def report_params
      params.permit(:department_id, :school_term_id)
    end
  end
end
