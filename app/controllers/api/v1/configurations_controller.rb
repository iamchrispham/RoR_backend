module Api::V1
  class ConfigurationsController < ApiController

    skip_before_filter :doorkeeper_authorize!, :current_api_user

    def generic
      configuration = configuration_service.generic_settings
      success_response(configuration: configuration)
    end

    private
    def configuration_service
      @configuration_service ||= ConfigurationService.new
    end
  end
end
