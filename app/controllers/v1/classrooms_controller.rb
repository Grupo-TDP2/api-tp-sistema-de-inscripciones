module V1
  class ClassroomsController < ApplicationController
    before_action -> { authenticate_user!(['Teacher']) }, only: [:index]

    def index
      render json: Classroom.all, include: ['building'], status: :ok
    end
  end
end
