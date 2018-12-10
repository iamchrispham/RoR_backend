module Showoff
  module Services
    class SmsService < ApiService
      include Api::ErrorHelper

      def send_sms(phone, message)
        sms_client.messages.create(
          to: phone,
          from: sms_number,
          body: message
        )
      rescue StandardError => e
        register_error(Showoff::ResponseCodes::INTERNAL_ERROR, I18n.t('showoff.services.sms.error_sending'))
      end

      private

      def sms_client
        Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      end

      def sms_number
        ENV['TWILIO_PHONE_NUMBER']
      end
    end
  end
end
