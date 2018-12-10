module Showoff
  module Payments
    module Serializers
      module Receipts
        class ReceiptVoucherSerializer < ActiveModel::Serializer
          include Showoff::Helpers::SerializationHelper

          attributes :id, :voucher

          def voucher
            voucher_serializer = instance_options[:voucher_serializer]

            if voucher_serializer
              serialized_resource(object.voucher, voucher_serializer, instance_options)
            else
              object.voucher.as_json
            end
          end
        end
      end
    end
  end
end
