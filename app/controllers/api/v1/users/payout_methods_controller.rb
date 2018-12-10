module Api
  module V1
    module Users
      class PayoutMethodsController < ApiController
        def index
          bank_accounts = payment_service.bank_accounts
          current_api_user.update_attributes(has_bank_account: !bank_accounts.empty?)
          success_response(payout_methods: serialized_resource(bank_accounts, Showoff::Payments::Providers::Serializers::BankAccountSerializer))
        end

        def create
          bank_accounts = payment_service.add_bank_account(payout_method_params[:token].strip)
          current_api_user.update_attributes(has_bank_account: !bank_accounts.empty?)
          success_response(payout_methods: serialized_resource(bank_accounts, Showoff::Payments::Providers::Serializers::BankAccountSerializer))
        end

        def destroy
          payment_service.remove_bank_account(params[:id])
          bank_accounts = payment_service.bank_accounts
          current_api_user.update_attributes(has_bank_account: !bank_accounts.empty?)
          success_response(payout_methods: serialized_resource(bank_accounts, Showoff::Payments::Providers::Serializers::BankAccountSerializer))
        end

        def default
          payment_service.make_bank_account_default(params[:payout_method_id])
          bank_accounts = payment_service.bank_accounts
          current_api_user.update_attributes(has_bank_account: !bank_accounts.empty?)

          if payment_service.errors.nil?
            success_response(payout_methods: serialized_resource(bank_accounts, Showoff::Payments::Providers::Serializers::BankAccountSerializer))
          else
            error = payment_service.errors.first
            error_response(error[:message], error[:type])
          end
        end

        rescue_from Showoff::Payments::Errors::ShowoffPaymentError do |exception|
          error_response(exception.message, Showoff::ResponseCodes::INVALID_ARGUMENT)
        end

        private

        def payout_method_params
          params.require(:payout_method).permit!
        end

        def payment_service
          @payment_service ||= Showoff::Payments::Services::PaymentService.new(vendor: current_api_user)
        end
      end
    end
  end
end
