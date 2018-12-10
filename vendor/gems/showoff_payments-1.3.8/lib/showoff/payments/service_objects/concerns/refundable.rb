module Showoff
  module Payments
    module Services
      module Concerns
        module Refundable
          extend Showoff::Payments::Services::Concerns::BaseConcern

          def refund(receipt:, application_fee: false, amount: nil, reverse_transfer: true)
            provider_identifier = :zero_refund
            refund_amount = 0
            if receipt.amount.nonzero? && (amount.nil? || amount.nonzero?)
              refund = client.refund(receipt: receipt, application_fee: application_fee, amount: amount, reverse_transfer: reverse_transfer)
              provider_identifier = refund.id
              refund_amount = refund.amount.to_f
            end

            charge_identifier = receipt.respond_to?(:provider_identifier) ? receipt.provider_identifier : receipt.id

            model_receipt = receipt.is_a?(Showoff::Payments::Receipt) ? receipt : ::Showoff::Payments::Receipt.find_by(provider_identifier: charge_identifier)
            refund_record = model_receipt.refunds.create(provider_identifier: provider_identifier, amount: refund_amount, application_fee: application_fee) if model_receipt

            refund_record
          rescue StandardError => e
            handle_error(e)
          end

          def refunds
            vendor_identity ? vendor_identity.refunds : Showoff::Payments::Refund.none
          rescue StandardError => e
            handle_error(e)
          end
        end
      end
    end
  end
end
