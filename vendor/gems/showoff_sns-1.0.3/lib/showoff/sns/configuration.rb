module Showoff
  module SNS
    class Configuration
      attr_accessor :access_key_id, :secret_access_key, :region
      attr_accessor :queue, :apns_endpoint, :gcm_endpoint
      attr_accessor :apns_enabled, :gcm_enabled

      def access_key_id
        @access_key_id ||= ENV['AWS_ACCESS_KEY_ID']
        check_configuration(@access_key_id, 'You must set an AWS Access Key ID')
      end

      def secret_access_key
        @secret_access_key ||= ENV['AWS_SECRET_ACCESS_KEY']
        check_configuration(@secret_access_key, 'You must set an AWS Secret Access Key')
      end

      def region
        @region ||= (ENV['AWS_REGION'] || 'eu-west-1')
        check_configuration(@region, 'You must set an AWS Region')
      end

      def queue
        @queue ||= :default
      end

      def apns_endpoint
        raise Showoff::SNS::EndpointDisabledError, 'APNS is disabled per Showoff::SNS configuration' unless apns_enabled
        @apns_endpoint ||= ENV['AWS_SNS_APNS_ENDPOINT']
        check_configuration(@apns_endpoint, 'You must set an APNS Endpoint')
      end

      def apns_enabled
        @apns_enabled = true if @apns_enabled.nil?
        @apns_enabled
      end

      def gcm_endpoint
        raise Showoff::SNS::EndpointDisabledError, 'GCM is disabled per Showoff::SNS configuration' unless gcm_enabled
        @gcm_endpoint ||= ENV['AWS_SNS_GCM_ENDPOINT']
        check_configuration(@gcm_endpoint, 'You must set a GCM Endpoint')
      end

      def gcm_enabled
        @gcm_enabled = true if @gcm_enabled.nil?
        @gcm_enabled
      end

      private

      def check_configuration(attribute, message)
        raise Showoff::SNS::ConfigurationError, message if attribute.nil?
        attribute
      end
    end
  end
end
