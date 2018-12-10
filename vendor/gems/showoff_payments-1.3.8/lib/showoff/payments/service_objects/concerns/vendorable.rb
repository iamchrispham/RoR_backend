module Showoff
  module Payments
    module Services
      module Concerns
        module Vendorable
          extend Showoff::Payments::Services::Concerns::BaseConcern

          def verify_vendor_identity(data)
            ensure_vendor
            client.verify_vendor_identity(data)
          rescue StandardError => e
            handle_error(e)
          end

          def vendor_payments_allowed?
            ensure_vendor
            client.vendor_payments_allowed?
          rescue StandardError => e
            handle_error(e)
          end

          def vendor_transfers_allowed?
            ensure_vendor
            client.vendor_transfers_allowed?
          rescue StandardError => e
            handle_error(e)
          end

          def vendor_verification_data
            ensure_vendor
            client.verification_data
          rescue StandardError => e
            handle_error(e)
          end

          def vendor_identification_data
            ensure_vendor
            client.identification_data
          rescue StandardError => e
            handle_error(e)
          end

          def provider_vendor
            ensure_vendor
            client.vendor
          rescue StandardError => e
            handle_error(e)
          end

          def vendor_supported_currencies
            ensure_vendor
            client.supported_currencies
          rescue StandardError => e
            handle_error(e)
          end

          def refresh_vendor_meta_data
            ensure_vendor
            client.refresh_vendor_meta_data
          rescue StandardError => e
            handle_error(e)
          end

          # bank accounts
          def bank_accounts
            ensure_vendor
            client.bank_accounts
          rescue StandardError => e
            handle_error(e)
          end

          def add_bank_account(bank_account_token)
            ensure_vendor
            client.add_bank_account(bank_account_token)
          rescue StandardError => e
            handle_error(e)
          end

          def remove_bank_account(bank_account_token)
            ensure_vendor
            client.remove_bank_account(bank_account_token)
          rescue StandardError => e
            handle_error(e)
          end

          def make_bank_account_default(bank_account_token)
            ensure_vendor
            client.make_bank_account_default(bank_account_token)
          rescue StandardError => e
            handle_error(e)
          end
        end
      end
    end
  end
end
