module Showoff
  module Payments
    module Serializers
      module Sources
        class OverviewSerializer < ActiveModel::Serializer
          attributes :id, :brand, :country, :cvc_check, :exp_month, :exp_year, :last_four, :provider_identifier
        end
      end
    end
  end
end
