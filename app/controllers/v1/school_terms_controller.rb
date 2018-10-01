module V1
  class SchoolTermsController < ApplicationController
    def index
      render json: school_terms, status: :ok
    end

    def create
      @school_term = SchoolTerm.new(school_term_params)
      @school_term.save
    end

    def show
      @school_term = SchoolTerm.find(params[:id])
      render json: @school_term, status: :ok
    end

    def destroy
      @school_term = SchoolTerm.find(params[:id])
      @school_term.destroy
    end

    private

    def school_term_params
      params.require(:school_term).permit(:term, :year, :date_start, :date_end)
    end

    def school_terms
      SchoolTerm.all
    end
  end
end
