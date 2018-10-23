class User < ApplicationRecord
  AUTHENTICATION_TOKEN_EXPIRATION_DAYS = Rails.application.secrets.expiration_date_days

  def authentication_token
    AuthenticationToken
      .generate_for(email, Time.zone.now + AUTHENTICATION_TOKEN_EXPIRATION_DAYS.days)
  end
end
