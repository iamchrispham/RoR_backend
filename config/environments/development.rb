Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end
  config.action_mailer.delivery_method = :letter_opener_web
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = {host: ENV.fetch('APPLICATION_HOST')}

  config.i18n.fallbacks = true
end

WillPaginate.per_page = 2

class ActionDispatch::Request
  def remote_ip
    '78.16.171.26'
  end
end

module Api
  module ServiceConstants
    module Geocoder
      SEARCH_DISTANCE = 100
      MAXIMUM_SEARCH_DISTANCE = 1000
    end
  end
end
