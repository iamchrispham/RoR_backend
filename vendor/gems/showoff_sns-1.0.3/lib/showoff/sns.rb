require 'aws-sdk'
require 'active_model_serializers'
require 'showoff_current_api_user'
require 'showoff_serializable'
require 'showoff/sns/configuration'

module Showoff
  module SNS
    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end
  end
end

require 'showoff/sns/models/concerns/notifiable'
require 'showoff/sns/models/notification'
require 'showoff/sns/models/notified_object'
require 'showoff/sns/models/notifier/base'
require 'showoff/sns/models/client'
require 'showoff/sns/models/device'
require 'showoff/sns/workers/notification_worker'
require 'showoff/sns/errors/configuration_error'
require 'showoff/sns/errors/endpoint_disabled_error'
require 'showoff/sns/serializers/device_serializer'
require 'showoff/sns/serializers/notification_serializer'
