module Showoff
  module SNS
    class Device
      class Serializer < ActiveModel::Serializer
        attributes :id, :platform, :uuid, :push_token, :endpoint_arn, :active
      end
    end
  end
end
