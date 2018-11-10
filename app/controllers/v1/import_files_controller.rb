module V1
  class ImportFilesController < ApplicationController
    before_action -> { authenticate_user!(['Admin']) }

    def index
      render json: ImportFile.all
    end

    def create
      if import_file_params[:model].match?(/student/i)
        result = StudentImport.new(import_file_params).process
      elsif import_file_params[:model].match?(/teacher/i)
        result = TeacherImport.new(import_file_params).process
      else
        return no_importer_response
      end
      render json: result, status: :ok
    end

    private

    def import_file_params
      params.permit(:file, :filename, :model)
    end

    def no_importer_response
      render json: { error: "#{import_file_params[:model]} has no importer set" },
             status: :unprocessable_entity
    end
  end
end
