module Showoff
  module Payments
    module Providers
      module BankAccounts
        class NotImplementedError < StandardError
        end

        class Base
          include ActiveModel::Serialization

          attr_reader :object

          def initialize(object)
            @object = object
          end

          def last_four
            raise Showoff::Payments::Providers::BankAccounts::NotImplementedError, I18n.t('payments.bank_accounts.undefined_method')
          end

          def method_missing(method)
            raise Showoff::Payments::Providers::BankAccounts::NotImplementedError, I18n.t('payments.bank_accounts.undefined_method') unless @object.respond_to?(method)
            @object.send(method)
          end
        end
      end
    end
  end
end
