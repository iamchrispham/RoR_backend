module Api
  module V1
    module Users
      class PaymentMethodsController < ApiController
        def index
          payment_methods = payment_service.sources
          current_api_user.update_attributes(has_payment_method: !payment_methods.empty?)
          success_response(payment_methods: serialized_resource(payment_methods, Payments::Source::OverviewSerializer))
        end

        def create
          payment_methods = payment_service.add_source(payment_method_params[:token])

          mark_first_as_default_if_required

          current_api_user.update_attributes(has_payment_method: !payment_methods.empty?)
          success_response(payment_methods: serialized_resource(payment_methods, Payments::Source::OverviewSerializer))
        end

        def destroy
          payment_service.remove_source(params[:id])
          payment_methods = payment_service.sources

          current_api_user.update_attributes(has_payment_method: !payment_methods.empty?)
          success_response(payment_methods: serialized_resource(payment_methods, Payments::Source::OverviewSerializer))
        end

        def default
          payment_service.make_source_default(params[:payment_method_id])
          payment_methods = payment_service.sources
          current_api_user.update_attributes(has_payment_method: !payment_methods.empty?)

          mark_first_as_default_if_required

          if payment_service.errors.nil?
            success_response(payment_methods: serialized_resource(payment_methods, Payments::Source::OverviewSerializer))
          else
            error = payment_service.errors.first
            error_response(error[:message], error[:type])
          end
        end

        rescue_from Showoff::Payments::Errors::ShowoffPaymentError do |exception|
          error_response(exception.message, Showoff::ResponseCodes::INVALID_ARGUMENT)
        end

        private

        def payment_method_params
          params.require(:payment_method).permit!
        end

        def payment_service
          @payment_service ||= Showoff::Payments::Services::PaymentService.new(customer: current_api_user)
        end

        def mark_first_as_default_if_required
          default = current_api_user.sources.default.active
          if default.count.zero?
            first_card = current_api_user.sources.active.first
            first_card.update_attributes(default: true) if first_card.present?
          end
        end
      end
    end
  end
end
