module Showoff
  module Payments
    class Configuration
      attr_accessor :provider, :managed_accounts_enabled

      def provider
        @provider ||= :stripe
        @provider
      end

      def managed_accounts_enabled
        @managed_accounts_enabled = false if @managed_accounts_enabled.nil?
        @managed_accounts_enabled
      end

      private
      def check_configuration(attribute, message)
        raise Showoff::Payments::ConfigurationError, message if attribute.nil?
        attribute
      end
    end
  end
end
