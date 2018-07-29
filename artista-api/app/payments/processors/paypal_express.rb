module Processors
  class PaypalExpress
    # include Processors::PaymentProcessorCommon
    attr_accessor :amount

    def initialize(attributes = {})
      @amount = attributes[:amount]
    end

    def setup_purchase(options = {})
      # validate_amount
      response = PAYPAL_GATEWAY.setup_purchase(
        amount.cents,
        ip: options[:ip],
        return_url: options[:return_url],
        cancel_return_url: options[:cancel_return_url],
        currency: amount.currency.iso_code,
        allow_guest_checkout: false,
        no_shipping: true,
        items: options[:items] || [{name: "Artifish", quantity: "1", amount: amount.cents}]
      )
      handle_unsuccessful_response(response)
      response.token
    end

    def redirect_url_for(token)
      PAYPAL_GATEWAY.redirect_url_for(token)
    end

    def checkout(options)
      token = options[:token]
      raise ExceptionHandler::InvalidOperation, Message.payment_was_already_processed if PaypalTransaction.find_by_token(token).present?

      details = PAYPAL_GATEWAY.details_for(token)
      @amount = Money.from_amount(details.params['amount'].to_f, details.params['amount_currency_id'])
      options[:currency] = @amount.currency.iso_code
      @paypal_transaction = PaypalTransaction.create!(token: token, amount: @amount, order_id: options[:app_order_id], payer: details.params['payer'])

      purchase(options)
      @paypal_transaction
    end

    private

      def purchase(purchase_options)
        response = PAYPAL_GATEWAY.purchase(amount.cents, purchase_options)
        handle_unsuccessful_response(response)
        @paypal_transaction.update_attributes(:success => true, :processor_authorization_code => response.authorization)
        response
      end

      def handle_unsuccessful_response(response)
        return if response.success?

        @paypal_transaction.update_attribute(:success, false) if @paypal_transaction

        error_number = response.params['error_codes']
        error_description = response.params['message']
        Rails.logger.error "Error #{error_number} in processing payment: #{error_description}"

        raise ExceptionHandler::PaymentProcessingError, Message.payment_processor_general_error
      end
  end
end
