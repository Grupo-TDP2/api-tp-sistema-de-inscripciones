module V1
  class PollsController < ApplicationController
    before_action -> { authenticate_user!(%w[Student]) }, only: %i[index create]

    def index
      render json: @current_user.polls, status: :ok
    end

    def create
      poll = Poll.new(create_poll_params.merge(student_id: @current_user.id))
      if poll.save
        head :created
      else
        render json: { errors: poll.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def create_poll_params
      params.require(:poll).permit(:course_id, :rate, :comment)
    end
  end
end
