class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    { user: user }
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find(decode_token[:user_id]) if decode_token
    rescue ActiveRecord::RecordNotFound => e
      raise ExceptionHandler::InvalidToken, "#{Message.invalid_token} #{e.message}"
  end

  def decode_token
    @decoded_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    raise(ExceptionHandler::MissingToken, Message.missing_token) if @headers['Authorization'].blank?
    @headers['Authorization'].split(' ').last
  end
end
