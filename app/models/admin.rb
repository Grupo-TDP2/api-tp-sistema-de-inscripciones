class Admin < ApplicationRecord
  AUTHENTICATION_TOKEN_EXPIRATION_DAYS = Rails.application.secrets.expiration_date_days
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def authentication_token
    AuthenticationToken.generate_for(id, Time.zone.now + AUTHENTICATION_TOKEN_EXPIRATION_DAYS.days)
  end
end
