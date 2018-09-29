module V1
  class SessionsController < ApplicationController
    include SessionConcern

    private

    def user
      @user ||= Student.find_by(email: authenticate_params[:email])
    end

    def authenticated_user?
      user.present? && user.valid_password?(authenticate_params[:password])
    end

    def authenticate_params
      params.permit(:email, :password)
    end
  end
end
