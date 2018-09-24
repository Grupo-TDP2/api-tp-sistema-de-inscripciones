module AuthenticationHelper
  def sign_in(user)
    request.headers['Authorization'] = user.authentication_token.to_s
  end
end
