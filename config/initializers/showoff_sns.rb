Showoff::SNS.configure do |config|
  config.access_key_id           = ENV['AWS_ACCESS_KEY_ID']
  config.secret_access_key       = ENV['AWS_SECRET_ACCESS_KEY']
  config.region                  = ENV['AWS_REGION']
  config.apns_endpoint           = ENV['AWS_SNS_APNS_ENDPOINT']
  config.gcm_endpoint            = ENV['AWS_SNS_GCM_ENDPOINT']
end

