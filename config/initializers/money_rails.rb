require 'money/bank/currencylayer_bank'

MoneyRails.configure do |config|

  # set the default currency
  config.default_currency = :eur

  # set default bank
  mclb = Money::Bank::CurrencylayerBank.new
  mclb.access_key = ENV['CURRENCY_LAYER_API_KEY']
  mclb.secure_connection = true
  mclb.ttl_in_seconds = 3600
  mclb.source = 'EUR'
  mclb.cache = Proc.new do |v|
    key = 'money:currencylayer_bank'
    if v
      AutoExpireCache.new[key] = v
    else
      AutoExpireCache.new[key]
    end
  end
  config.default_bank = mclb

end

