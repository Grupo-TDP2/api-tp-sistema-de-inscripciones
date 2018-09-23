module V1
  class EnrolmentsController < ApplicationController
    def create
    end

    private

    def course
      @course ||= Course.find(params[:course_id])
    end
  end
end
