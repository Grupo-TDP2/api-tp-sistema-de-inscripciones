class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  attr_reader :current_user

  rescue_from UnauthorizedUserException, with: :unauthorized_user

  # i18n configuration. See: http://guides.rubyonrails.org/i18n.html
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: locale }
  end

  # for devise to redirect with locale
  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  def index; end

  private

  def authenticate_user!(entities)
    @current_user = AuthenticationToken.new(authentication_token).user(entities)
  end

  def authentication_token
    request.headers.fetch('Authorization', '').split('Bearer ').last
  end

  def unauthorized_user
    head :unauthorized
  end
end
