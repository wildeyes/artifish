MoneyRails.configure do |config|

  # To set the default currency
  #
  # config.default_currency = :usd

  config.default_format = {
    no_cents_if_whole: true,
  }
end
