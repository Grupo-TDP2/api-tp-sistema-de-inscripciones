module V1
  class SchoolTermsController < ApplicationController
    before_action -> { authenticate_user!(['Admin']) }
    def index
      render json: school_terms, status: :ok
    end

    def create
      school_term = SchoolTerm.new(school_term_params)
      if school_term.save
        render json: school_term, status: :created
      else
        render json: school_term.errors.full_messages, status: :unprocessable_entity
      end
    end

    def show
      school_term = SchoolTerm.find(params[:id])
      render json: school_term, status: :ok
    end

    def destroy
      school_term = SchoolTerm.find(params[:id])
      if school_term.destroy
        head :ok
      else
        render json: school_term.errors.full_messages, status: :unprocessable_entity
      end
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
