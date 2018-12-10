module Showoff
  module Payments
    module Serializers
      module Refunds
        class OverviewSerializer < ActiveModel::Serializer
          include Showoff::Helpers::SerializationHelper

          attributes :id, :amount, :currency, :purchase, :created_at, :receipt, :customer, :vendor

          def currency
            object.currency
          end

          def receipt
            if instance_options[:include_receipt]
              serialized_resource(object.receipt, Showoff::Payments::Serializers::Receipts::OverviewSerializer, instance_options)
            end
          end

          def purchase
            if instance_options[:include_purchase]
              purchase_serializer = instance_options[:purchase_serializer]

              if purchase_serializer
                purchase_serializer = purchase_serializer.call(object.purchase) if purchase_serializer.respond_to?(:call)
                serialized_resource(object.purchase, purchase_serializer, instance_options)
              else
                object.purchase.as_json
              end
            end
          end

          def customer
            if instance_options[:include_customer]
              customer_serializer = instance_options[:customer_serializer]
              if customer_serializer
                serialized_resource(object.customer, customer_serializer, instance_options)
              else
                object.customer.as_json
              end
            end
          end

          def vendor
            if instance_options[:include_vendor]
              vendor_serializer = instance_options[:vendor_serializer]
              if vendor_serializer
                serialized_resource(object.vendor, vendor_serializer, instance_options)
              else
                object.vendor.as_json
              end
            end
          end
        end
      end
    end
  end
end
