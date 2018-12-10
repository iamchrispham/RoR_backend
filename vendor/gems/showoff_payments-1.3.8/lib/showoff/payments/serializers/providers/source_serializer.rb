module Showoff
  module Payments
    module Providers
      module Serializers
        class SourceSerializer < ActiveModel::Serializer
          attributes :id, :brand, :country, :cvc_check, :exp_month, :exp_year, :last_four
        end
      end
    end
  end
end
