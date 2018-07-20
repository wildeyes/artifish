class Message
  class << self
    def not_found(record = 'record')
      { message: :not_found, description: "Sorry, #{record} not found" }.to_json
    end

    def invalid_credentials
      { message: :invalid_credentials, description: 'Invalid credentials' }.to_json
    end

    def invalid_token
      { message: :invalid_token, description: 'Invalid token' }.to_json
    end

    def missing_token
      { message: :missing_token, description: 'Missing token' }.to_json
    end

    def unauthorized
      { message: :unauthorized, description: 'Unauthorized request' }.to_json
    end

    def internal_error
      { message: :internal_error, description: 'Sorry, an internal server error has occured' }.to_json
    end

    def user_created
      { message: :user_created, description: 'User created successfully' }.to_json
    end

    def expired_token
      { message: :expired_token, description: 'Sorry, your token has expired. Please login to continue' }.to_json
    end

    def missing_parameter(param)
      { message: :missing_parameter, description: "Missing parameter: #{param}" }.to_json
    end

    def incorrect_verification_code
      { message: :incorrect_verification_code, description: "Verification code is incorrect" }.to_json
    end

    def user_not_verified
      { message: :user_not_verified, description: "User is not verified" }.to_json
    end
  end
end
