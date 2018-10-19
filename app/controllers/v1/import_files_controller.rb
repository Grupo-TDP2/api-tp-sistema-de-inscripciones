module V1
  class ImportFilesController < ApplicationController
    before_action -> { authenticate_user!(['Admin']) }

    def create
      if import_file_params[:model].match?(/student/i)
        result = StudentImport.new(import_file_params).process
        render json: result, status: :ok
      else
        render json: { error: "#{import_file_params[:model]} has no importer set" },
               status: :unprocessable_entity
      end
    end

    private

    def import_file_params
      params.require(:import_file).permit(:file, :filename, :model)
    end
  end
end
