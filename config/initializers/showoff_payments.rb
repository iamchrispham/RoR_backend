Showoff::Payments.configure do |config|
  config.managed_accounts_enabled  = true
  config.provider = :stripe
end
