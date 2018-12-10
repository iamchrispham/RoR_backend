module Showoff
  module Payments
    module Serializers
      class ProviderSerializer < ActiveModel::Serializer
        attributes :id, :name
      end
    end
  end
end
