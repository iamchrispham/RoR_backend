module Events
  module Contributions
    class OverviewSerializer < ApiSerializer
      attributes :id, :status, :amount, :updated_at

      def amount
        {
            cents: object.amount_cents,
            currency: serialized_resource(instance_currency.present? ? instance_currency : object.amount.currency, ::Countries::Currencies::OverviewSerializer)
        }
      end

    end
  end
end
