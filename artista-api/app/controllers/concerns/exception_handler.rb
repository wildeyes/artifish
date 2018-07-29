module ExceptionHandler
  extend ActiveSupport::Concern

  class InternalError < StandardError; end
  class BadRequest < StandardError; end
  class Forbidden < StandardError; end
  class AuthenticationError < StandardError; end
  class NotVerifiedError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class InvalidOperation < StandardError; end
  class PaymentProcessingError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two_record_invalid
    rescue_from ExceptionHandler::InternalError, with: :internal_error
    rescue_from ExceptionHandler::BadRequest, with: :bad_request
    rescue_from ExceptionHandler::Forbidden, with: :forbidden
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::NotVerifiedError, with: :forbidden
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidOperation, with: :four_twenty_two
    rescue_from ExceptionHandler::PaymentProcessingError, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json = JSON.parse(e.message) rescue nil || { message: e.message }
      json_response(json, :not_found)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      json = Message.already_exists
      json_response(json, :unprocessable_entity)
    end

    # JSON response with message; Status code 422 - unprocessable entity
    def four_twenty_two_record_invalid(e)
      json_response({ validations: e.record.errors.messages }, :unprocessable_entity)
    end

    def four_twenty_two(e)
      json = JSON.parse(e.message) rescue nil || { message: e.message }
      json_response(json, :unprocessable_entity)
    end

    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(e)
      json = JSON.parse(e.message) rescue nil || { message: e.message }
      json_response(json, :unauthorized)
    end

    # JSON response with message; Status code 500 - Internal Server Error
    def internal_error(e)
      json = JSON.parse(e.message) rescue nil || { message: e.message }
      json_response(json, :internal_server_error)
    end

    # JSON response with message; Status code 400 - Bad Request
    def bad_request(e)
      json = JSON.parse(e.message) rescue nil || { message: e.message }
      json_response(json, :bad_request)
    end

    # JSON response with message; Status code 403 - Forbidden
    def forbidden(e)
      json = JSON.parse(e.message) rescue nil || { message: e.message }
      json_response(json, :forbidden)
    end
  end
end
