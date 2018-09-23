class AuthenticationToken
  HMAC_SECRET = Rails.application.secrets.hmac_secret

  class << self
    def generate_for(id, expiration)
      payload = { data: { id: id }, exp: expiration.to_i }
      JWT.encode(payload, HMAC_SECRET, 'HS256')
    end
  end

  def initialize(token)
    @payload = decode(token)
  end

  def user
    Student.find_by(id: @payload.dig('data', 'id')).tap do |user|
      raise UnauthorizedUserException if user.blank?
    end
  end

  private

  def decode(token)
    JWT.decode(token, HMAC_SECRET, true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError
    {}
  end
end
