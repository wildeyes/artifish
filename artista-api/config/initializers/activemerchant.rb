if Rails.env == "development"
  ActiveMerchant::Billing::Base.mode = :test

  paypal_login = ENV['PAYPAL_USERNAME_TEST']
  paypal_password = ENV['PAYPAL_PASSWORD_TEST']
  paypal_signature = ENV['PAYPAL_SIGNATURE_TEST']
elsif Rails.env == "production"
  paypal_login = ENV['PAYPAL_USERNAME']
  paypal_password = ENV['PAYPAL_PASSWORD']
  paypal_signature = ENV['PAYPAL_SIGNATURE']
end

PAYPAL_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new({
      login: paypal_login,
      password: paypal_password,
      signature: paypal_signature
})
