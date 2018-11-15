module V1
  class ReportsController < ApplicationController
    before_action -> { authenticate_user!(['Admin DepartmentStaff']) }

    def polls
      render json: ImportFile.all
    end

    def subject_enrolments

    end

    private

    def report_params
      params.permit(:department_id, :school_term_id)
    end
  end
end
