module Showoff
  module Payments
    module Providers
      module Sources
        class NotImplementedError < StandardError
        end

        class Base
          include ActiveModel::Serialization

          attr_reader :object

          def initialize(object)
            @object = object
          end

          def last_four
            raise Showoff::Payments::Providers::Sources::NotImplementedError, I18n.t('payments.sources.undefined_method')
          end

          def provider_identifier
            raise Showoff::Payments::Providers::Sources::NotImplementedError, I18n.t('payments.sources.undefined_method')
          end

          def method_missing(method)
            raise Showoff::Payments::Providers::Sources::NotImplementedError, I18n.t('payments.sources.undefined_method') unless @object.respond_to?(method)
            @object.send(method)
          end
        end
      end
    end
  end
end
