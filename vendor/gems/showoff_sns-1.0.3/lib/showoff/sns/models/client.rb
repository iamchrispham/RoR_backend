module Aws
  module SNS
    class Client
      def notify(device, message, extra_info)
        notification = {
          aps: {
            alert: message,
            extra: extra_info,
            sound: 'default',
            badge: 1
          }
        }

        sns_message = {
          default: message,
          APNS_SANDBOX: notification.to_json,
          APNS: notification.to_json,
          GCM: {
            data: notification
          }.to_json
        }

        publication = {
          target_arn: device.endpoint_arn,
          message: sns_message.to_json,
          message_structure: 'json'
        }

        begin
          Rails.logger.debug "Sending Notification: #{sns_message.to_json} to #{device.endpoint_arn}"
          publish(publication)
        rescue StandardError => e
          Rails.logger.error "Error, cannot send push note: #{e}, Endpoint: #{device.endpoint_arn}"
        end
      end
    end
  end
end

module Showoff
  module SNS
    attr_reader :client

    private

    def self.endpoint_arn(device)
      client.delete_endpoint(endpoint_arn: device.endpoint_arn) if device.endpoint_arn
      create_endpoint_arn(device)
    end

    def self.client
      @client ||= begin
        Aws.config[:credentials] = Aws::Credentials.new(Showoff::SNS.configuration.access_key_id, Showoff::SNS.configuration.secret_access_key)
        Aws.config[:region] = Showoff::SNS.configuration.region
        Aws::SNS::Client.new
      end
    end

    private

    def self.apns_endpoint(device)
      device.endpoint_owner && device.endpoint_owner.respond_to?(:apns_endpoint) ? device.endpoint_owner.apns_endpoint : configuration.apns_endpoint
    end

    def self.gcm_endpoint(device)
      device.endpoint_owner && device.endpoint_owner.respond_to?(:gcm_endpoint) ? device.endpoint_owner.gcm_endpoint : configuration.gcm_endpoint
    end

    def self.create_endpoint_arn(device)
      arn = device.platform.to_sym.eql?(:ios) ? apns_endpoint(device) : gcm_endpoint(device)
      endpoint = client.create_platform_endpoint(platform_application_arn: arn, token: device.push_token)
      endpoint[:endpoint_arn]
    end
  end
end
