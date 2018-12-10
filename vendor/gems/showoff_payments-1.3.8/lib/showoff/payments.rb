require 'showoff/payments/errors'
require 'showoff/payments/models'
require 'showoff/payments/serializers'
require 'showoff/payments/service_objects'
require 'showoff/payments/configuration'

module Showoff
  module Payments
    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end
  end
end