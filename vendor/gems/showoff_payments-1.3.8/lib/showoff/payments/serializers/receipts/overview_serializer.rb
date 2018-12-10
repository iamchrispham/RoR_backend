module Showoff
  module Payments
    module Serializers
      module Receipts
        class OverviewSerializer < ActiveModel::Serializer
          include Showoff::Helpers::SerializationHelper

          attributes :id, :status, :amount, :currency, :application_fee, :quantity, :notes, :purchase, :customer, :vendor, :refunded, :refunded_amount, :partially_refunded, :totally_refunded, :refunds, :created_at, :item_price, :receipt_vouchers, :address, :credits

          def item_price
            (object.amount / object.quantity).round(2)
          end

          def purchase
            purchase_serializer = instance_options[:purchase_serializer]

            if purchase_serializer
              purchase_serializer = purchase_serializer.call(object.purchase) if purchase_serializer.respond_to?(:call)
              serialized_resource(object.purchase, purchase_serializer, instance_options)
            else
              object.purchase.as_json
            end
          end

          def address
            address_serializer = instance_options[:address_serializer]

            if address_serializer
              serialized_resource(object.address, address_serializer, instance_options)
            else
              object.address.as_json
            end
          end

          def customer
            if instance_options[:include_customer]
              customer_serializer = instance_options[:customer_serializer]
              if customer_serializer
                serialized_resource(object.customer_identity.customer, customer_serializer, instance_options)
              else
                object.customer_identity.customer.as_json
              end
            end
          end

          def vendor
            if instance_options[:include_vendor]
              vendor_serializer = instance_options[:vendor_serializer]
              if vendor_serializer
                serialized_resource(object.vendor_identity.vendor, vendor_serializer, instance_options)
              else
                object.vendor_identity.vendor.as_json
              end
            end
          end

          def refunded
            object.refunds.count > 0
          end

          def partially_refunded
            refunded_amount < object.amount
          end

          def totally_refunded
            !partially_refunded
          end

          def refunded_amount
            object.refunds.sum(:amount)
          end

          def refunds
            if instance_options[:include_refunds]
              serialized_resource(object.refunds, Showoff::Payments::Serializers::Refunds::OverviewSerializer, instance_options)
            end
          end

          def receipt_vouchers
            if instance_options[:include_vouchers]
              serialized_resource(object.receipt_vouchers, Showoff::Payments::Serializers::Receipts::ReceiptVoucherSerializer, instance_options)
            end
          end
        end
      end
    end
  end
end
