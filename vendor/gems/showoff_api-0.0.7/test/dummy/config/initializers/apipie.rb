Apipie.configure do |config|
  config.app_name                = 'Showoff::API::Doc Example'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api/documentation'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
end
