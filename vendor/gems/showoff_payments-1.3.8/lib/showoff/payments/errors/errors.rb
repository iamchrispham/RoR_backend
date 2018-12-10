module Showoff
  module Payments
    module Errors
      class ShowoffPaymentError < StandardError
      end

      class CardError < ShowoffPaymentError
      end

      class RateLimitError < ShowoffPaymentError
      end

      class InvalidRequestError < ShowoffPaymentError
      end

      class AuthenticationError < ShowoffPaymentError
      end

      class APIConnectionError < ShowoffPaymentError
      end

      class PaymentError < ShowoffPaymentError
      end

      class CustomerMissingError < ShowoffPaymentError
      end

      class VendorMissingError < ShowoffPaymentError
      end

      class VendorDataMissingError < ShowoffPaymentError
      end

      class ProviderMissingError < ShowoffPaymentError
      end

      class VendorIdentificationError < ShowoffPaymentError
      end

      class PurchaseMissingError < ShowoffPaymentError
      end

      def handle_error(e, provider = nil)
        provider_id = "#{provider}#{(provider.nil? ? '' : ':')} "
        error_message = "#{provider_id}#{e.message}"
        raise e
      rescue Stripe::CardError
        raise Showoff::Payments::Errors::CardError, error_message
      rescue Stripe::RateLimitError
        raise Showoff::Payments::Errors::RateLimitError, error_message
      rescue Stripe::InvalidRequestError
        raise Showoff::Payments::Errors::InvalidRequestError, error_message
      rescue Stripe::AuthenticationError
        raise Showoff::Payments::Errors::AuthenticationError, error_message
      rescue Stripe::APIConnectionError
        raise Showoff::Payments::Errors::APIConnectionError, error_message
      rescue Stripe::StripeError
        raise Showoff::Payments::Errors::PaymentError, error_message
      rescue
        raise e
      end
    end
  end
end
