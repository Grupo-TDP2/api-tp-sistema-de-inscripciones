module V1
  class SessionsController < ApplicationController
    def create
      if authenticated_user?
        render json: {
          access_token: user.authentication_token,
          role: user.class.name,
          user: user,
          expires_in: Rails.application.secrets.expiration_date_days.days.seconds
        }, status: :ok
      else
        render json: { error: 'Credenciales inválidas' }, status: :unauthorized
      end
    end

    private

    def authenticated_user?
      user.present? && user.valid_password?(authenticate_params[:password])
    end

    def authenticate_params
      params.permit(:email, :password)
    end

    def user
      @user ||= Admin.find_by(email: authenticate_params[:email]) ||
                DepartmentStaff.find_by(email: authenticate_params[:email]) ||
                Teacher.find_by(email: authenticate_params[:email]) ||
                Student.find_by(email: authenticate_params[:email])
    end
  end
end
