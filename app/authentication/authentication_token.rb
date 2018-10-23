class AuthenticationToken
  HMAC_SECRET = Rails.application.secrets.hmac_secret

  class << self
    def generate_for(email, expiration)
      payload = { data: { email: email }, exp: expiration.to_i }
      JWT.encode(payload, HMAC_SECRET, 'HS256')
    end
  end

  def initialize(token)
    @payload = decode(token)
  end

  def user(entities)
    users = entities.map do |entity|
      entity.constantize.find_by(email: @payload.dig('data', 'email'))
    end
    raise UnauthorizedUserException unless users.any?
    users.compact.first
  end

  private

  def decode(token)
    JWT.decode(token, HMAC_SECRET, true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError
    {}
  end
end
