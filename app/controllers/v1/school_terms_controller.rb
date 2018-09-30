module V1
  class SchoolTermsController < ApplicationController

    def index
      SchoolTerm.all
    end

    def create
      @school_term = SchoolTerm.new(school_term_params)
      @school_term.save
    end

    private
    def school_term_params
      params.require(:school_term).permit(:term, :year, :date_start, :date_end)
    end

    def show
      @school_term = SchoolTerm.find(params[:id])
    end

    def destroy
      @school_term = SchoolTerm.find(params[:id])
      @school_term.destroy
    end
  end
end
