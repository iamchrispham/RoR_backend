module Showoff
  module Payments
    module Providers
      module Customers
        class NotImplementedError < StandardError
        end

        class Base
          include ActiveModel::Serialization

          attr_reader :object

          def initialize(object)
            @object = object
          end

          def method_missing(method)
            raise Showoff::Payments::Providers::Customers::NotImplementedError, I18n.t('payments.customers.undefined_method') unless @object.respond_to?(method)
            @object.send(method)
          end
        end
      end
    end
  end
end
