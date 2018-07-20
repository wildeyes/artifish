class AuthenticateUser
  include AuthenticateUserCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  private

  def user
    user = User.find_by_email(@email)
    return user if user && user.authenticate(@password)

    raise ExceptionHandler::AuthenticationError, Message.invalid_credentials
  end
end
