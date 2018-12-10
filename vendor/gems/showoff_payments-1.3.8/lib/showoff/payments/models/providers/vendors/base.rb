module Showoff
  module Payments
    module Providers
      module Vendors
        class NotImplementedError < StandardError
        end

        class Base
          include ActiveModel::Serialization

          # Exposes all attributes of Stripe::Account by default

          attr_reader :object

          def initialize(object)
            @object = object
          end

          def method_missing(method)
            raise Showoff::Payments::Providers::Vendors::NotImplementedError, I18n.t('payments.vendors.undefined_method') unless @object.respond_to?(method)
            @object.send(method)
          end
        end
      end
    end
  end
end
