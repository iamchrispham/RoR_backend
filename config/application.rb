require File.expand_path('../boot', __FILE__)
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
Bundler.require(*Rails.groups)
module GoAppApi
  class Application < Rails::Application
    config.quiet_assets = true
    config.generators do |generate|
      generate.helper false
      generate.template_engine :slim
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += Dir[Rails.root.join('app', 'notifiers', '**', '*.{rb,yml}')]

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = %w(en)

    config.to_prepare do
      Devise::Mailer.layout 'mailer'
      DeviseController.respond_to :html, :json
      Doorkeeper::ApplicationsController.layout "application"
      Doorkeeper::AuthorizationsController.layout "application"
      Doorkeeper::AuthorizedApplicationsController.layout "application"
      Doorkeeper::ApplicationController.helper GoAppApi::Application.helpers
    end

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins ENV.fetch('ALLOWED_CORS_ORIGINS')
        resource '*', headers: :any, methods: %i[get post put patch delete options]
      end
    end
  end
end

module ActiveRecord
  class Base
    def self.establish_connection(spec = ENV["DATABASE_URL"].try(:gsub, "postgres", "postgis"))
      super(spec)
    end
  end
end


