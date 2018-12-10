module Events
  module Contributions
    module Details
      class OverviewSerializer < ApiSerializer
        attributes :id, :event_contribution_type, :amount, :go_amount, :total_amount, :reason, :optional

        def event_contribution_type
          serialized_resource(object.event_contribution_type, ::Events::Contributions::Types::OverviewSerializer, contribution_details: object)
        end

        def amount
          {
              cents: object.amount_cents,
              currency: serialized_resource(instance_currency.present? ? instance_currency : object.amount.currency, ::Countries::Currencies::OverviewSerializer)
          }
        end

        def go_amount
          {
              cents: object.go_fee_cents,
              currency: serialized_resource(instance_currency.present? ? instance_currency : object.amount.currency, ::Countries::Currencies::OverviewSerializer)
          }
        end

        def total_amount
          {
              cents: object.total_amount_cents,
              currency: serialized_resource(instance_currency.present? ? instance_currency : object.amount.currency, ::Countries::Currencies::OverviewSerializer)
          }
        end

      end
    end
  end
end
