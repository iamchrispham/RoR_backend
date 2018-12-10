module Showoff
  module Payments
    module Providers
      module Serializers
        class BankAccountSerializer < ActiveModel::Serializer
          attributes :id, :account_holder_name, :account_holder_type, :bank_name, :country, :currency, :last_four, :routing_number
        end
      end
    end
  end
end