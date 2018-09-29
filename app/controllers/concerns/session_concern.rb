module SessionConcern
  extend ActiveSupport::Concern

  def create
    if authenticated_user?
      render json: {
        access_token: user.authentication_token,
        expires_in: Rails.application.secrets.expiration_date_days.days.seconds
      }, status: :ok
    else
      render json: { error: 'Credenciales inválidas' }, status: :unauthorized
    end
  end
end
