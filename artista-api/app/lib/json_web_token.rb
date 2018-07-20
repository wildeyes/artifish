class JsonWebToken
  class << self
    HMAC_SECRET = Rails.application.secrets.secret_key_base

    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i

      JWT.encode(payload, HMAC_SECRET)
    end

    def decode(token)
      begin
        payload = JWT.decode(token, HMAC_SECRET)[0]
        HashWithIndifferentAccess.new(payload)
      rescue JWT::DecodeError => e
        raise ExceptionHandler::InvalidToken, "#{Message.invalid_token} #{e.message}"
      end
    end
  end
end
