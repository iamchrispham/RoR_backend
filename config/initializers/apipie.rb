Apipie.configure do |config|
  config.app_name                = 'Go API'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api/documentation'
  config.reload_controllers	     = true
  config.validate                = false
  config.api_controllers_matcher = ["#{Rails.root}/app/controllers/api/**/**/*.rb", "#{Rails.root}/app/controllers/api/**/*.rb"]
  config.app_info                = 'Go API Documentation'
  config.namespaced_resources    = true

  config.authenticate = proc do
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['APIPIE_USERNAME'] && password == ENV['APIPIE_PASSWORD']
    end
  end
end
