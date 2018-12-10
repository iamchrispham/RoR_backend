module Showoff
  module Payments
    module Providers
      module Clients
        class NotImplementedError < NoMethodError
        end

        class Base
          attr_reader :vendor_identity, :vendor

          def initialize(vendor_identity)
            @vendor_identity = vendor_identity
            @vendor = @vendor_identity.vendor unless @vendor_identity.blank?
          end

          def charge(customer_identity:, amount: ,purchase: ,currency: , application_fee:, source: nil)
            raise NotImplementedError
          end

          def sources(customer_identity)
            raise NotImplementedError
          end

          def add_source(customer_identity, source_token)
            raise NotImplementedError
          end

          def remove_source(customer_identity, source_token)
            raise NotImplementedError
          end

          def make_default(customer_identity, source_token)
            raise NotImplementedError
          end

          def bank_accounts
            raise NotImplementedError
          end

          def add_bank_account(bank_account_token)
            raise NotImplementedError
          end

          def remove_bank_account(bank_account_token)
            raise NotImplementedError
          end

          def make_bank_account_default(bank_account_token)
            raise NotImplementedError
          end

          def verify_vendor_identity(data)
            raise NotImplementedError
          end

          def vendor_payments_allowed?
            raise NotImplementedError
          end

          def required_vendor_fields
            raise NotImplementedError
          end

          def refresh_vendor_meta_data
            raise NotImplementedError
          end

          def create_customer_identity(customer, provider)
            raise NotImplementedError
          end

          def customer(customer_identity)
            raise NotImplementedError
          end

          def self.create_vendor_identity(vendor)
            raise NotImplementedError
          end

          private

          def external_refund_service
            raise NotImplementedError
          end

          def external_charge_service
            raise NotImplementedError
          end

          def external_customer_service
            raise NotImplementedError
          end

          def create_customer(customer, _source = nil)
            raise NotImplementedError
          end

          def provider_identifier
            return nil if @vendor_identity.blank?
            @vendor_identity.provider_identifier
          end

          def self.external_account_service
            raise NotImplementedError
          end

          def self.provider
            raise NotImplementedError
          end

          def self.create_vendor(vendor)
            raise NotImplementedError
          end

          def self.create_managed_vendor(vendor)
            raise NotImplementedError
          end

          def self.validate_vendor_data(data)
            raise NotImplementedError
          end

        end
      end
    end
  end
end
