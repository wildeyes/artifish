module AuthenticateUserCommand
  def call
    u = user
    JsonWebToken.encode(AuthenticateUserCommand.auth_token_data(u)) if u
  end

  def self.auth_token_data(u)
    { user_id: u.id, first_name: u.first_name, last_name: u.last_name, verified: u.is_verified }
  end
end
