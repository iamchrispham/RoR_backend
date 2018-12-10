module Showoff
  module Payments
    module Providers
      module Refunds
        class NotImplementedError < StandardError
        end

        class Base
          include ActiveModel::Serialization

          attr_reader :object

          def initialize(object)
            @object = object
          end

          def method_missing(method)
            raise Showoff::Payments::Providers::Refunds::NotImplementedError, I18n.t('payments.refunds.undefined_method') unless @object.respond_to?(method)
            @object.send(method)
          end
        end
      end
    end
  end
end
