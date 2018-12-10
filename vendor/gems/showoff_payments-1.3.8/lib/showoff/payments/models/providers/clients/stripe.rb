require 'stripe'
require 'uri'
require 'net/http'
require 'pathname'
require 'tempfile'

module Showoff
  module Payments
    module Providers
      module Clients
        class Stripe < Base

          # Charges
          def charge(customer_identity:, amount: , purchase: ,currency: , application_fee:, source: nil)

            if ::Showoff::Payments.configuration.managed_accounts_enabled

              destination_amount = amount
              destination_amount = amount - application_fee if application_fee.present?

              params =  {
                  amount: amount,
                  currency: currency,
                  customer: customer_identity.provider_identifier
              }
              if provider_identifier
                params[:destination] = {
                    amount: destination_amount,
                    account: provider_identifier
                }
              end

              #support charging a specific card on a customer
              params[:source] = source.provider_identifier if source

              charge = external_charge_service.create(params)
            else

              params = {
                  amount: amount,
                  currency: currency,
                  customer: customer_identity.provider_identifier,
                  application_fee: application_fee
              }

              #support charging a specific card on a customer
              params[:source] = source.provider_identifier if source

              #create charge
              charge = external_charge_service.create(params, stripe_account)
            end

            ::Showoff::Payments::Providers::Receipts::Stripe.new(charge)
          end

          def charges(customer_identity = nil)
            customer_identifier = customer_identity.nil? ? nil : customer_identity.provider_identifier
            charges = []

            if ::Showoff::Payments.configuration.managed_accounts_enabled
              external_charge_service.list({ customer: customer_identifier }).auto_paging_each do |charge|
                charges << ::Showoff::Payments::Providers::Receipts::Stripe.new(charge)
              end
            else
              external_charge_service.list({ customer: customer_identifier }, stripe_account).auto_paging_each do |charge|
                charges << ::Showoff::Payments::Providers::Receipts::Stripe.new(charge)
              end
            end

            charges
          end

          # Refunds
          def refund(receipt:, application_fee: false, amount: nil, reverse_transfer: true)
            charge_identifier = receipt.respond_to?(:provider_identifier) ? receipt.provider_identifier : receipt.id

            if ::Showoff::Payments.configuration.managed_accounts_enabled
              refund = external_refund_service.create({
                                                          charge: charge_identifier,
                                                          amount: amount,
                                                          reverse_transfer: reverse_transfer,
                                                      })
            else
              refund = external_refund_service.create({
                                                          amount: amount,
                                                          refund_application_fee: application_fee,
                                                          charge: charge_identifier,
                                                      }, stripe_account)
            end


            ::Showoff::Payments::Providers::Refunds::Stripe.new(refund)
          end

          def refunds
            refunds = []

            external_refund_service.list({}, stripe_account).auto_paging_each do |refund|
              refunds << ::Showoff::Payments::Providers::Refunds::Stripe.new(refund)
            end

            refunds
          end

          # Payment Sources
          def sources(customer_identity)
            sources = []

            customer(customer_identity).sources.auto_paging_each do |source|
              sources << ::Showoff::Payments::Providers::Sources::Stripe.new(source)
            end

            sources
          end

          def add_source(customer_identity, source_token)
            customer(customer_identity).sources.create(source: source_token)

            sources(customer_identity)
          end

          def remove_source(customer_identity, source_token)
            customer(customer_identity).sources.retrieve(source_token).delete

            sources(customer_identity)
          end

          def make_default(customer_identity, source_token)
            customer = stripe_customer(customer_identity)
            customer.default_source = source_token
            customer.save

            sources(customer_identity)
          end

          # Customers
          def create_customer_identity(customer, provider)
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              Showoff::Payments::Customers::Identity.create(customer: customer, provider_identifier: create_customer(customer).id, provider: provider)
            else
              Showoff::Payments::Customers::Identity.create(customer: customer, provider_identifier: create_customer(customer).id, provider: provider, vendor_identity: @vendor_identity)
            end
          end

          def customer(customer_identity)
            customer = stripe_customer(customer_identity)
            ::Showoff::Payments::Providers::Customers::Stripe.new(customer)
          end

          # Vendors
          def self.create_vendor_identity(vendor, options = {})
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              provider_vendor = create_managed_vendor(vendor)
              vendor.vendor_identities.create(
                  provider_identifier: provider_vendor.id,
                  provider: provider,
                  vendor_identity_type: ::Showoff::Payments::Vendors::Identity.vendor_identity_types[:managed],
                  provider_secret: provider_vendor.keys.secret,
                  provider_key: provider_vendor.keys.publishable
              )
            else
              vendor.vendor_identities.create(provider_identifier: create_vendor(vendor).id, provider: provider)
            end
          end

          def vendor(force_store_meta_data: false)
            vendor = self.class.external_account_service.retrieve(vendor_identity.provider_identifier)
            update_meta_data(vendor) if force_store_meta_data

            ::Showoff::Payments::Providers::Vendors::Stripe.new(vendor)
          end

          def verify_vendor_identity(data)
            raise Showoff::Payments::Errors::VendorIdentificationError, I18n.t('payments.vendors.vendor_identification_error') if data.blank?

            account = vendor

            update_legal_entity(account, data[:legal_entity]) if data[:legal_entity]

            identification_hash = data[:identification]
            try_verify_identity(account, identification_hash) if identification_hash

            account.save

            vendor(force_store_meta_data: true)
          end

          def vendor_payments_allowed?
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              return vendor_identity_meta_data.payments_charges_enabled
            end
            true
          end

          def vendor_transfers_allowed?
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              return vendor_identity_meta_data.payments_transfers_enabled
            end
            true
          end

          def verification_data
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              return {
                  field_required: vendor_identity_meta_data.verification_fields_required,
                  disabled_reason: vendor_identity_meta_data.verification_fields_disabled_reason,
                  required_by: vendor_identity_meta_data.verification_fields_required_by
              }
            end
            {}
          end

          def identification_data
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              return {
                  status: vendor_identity_meta_data.identification_status,
                  details: vendor_identity_meta_data.identification_details,
                  details_code: vendor_identity_meta_data.identification_details_code,
                  uploaded_identifier: vendor_identity_meta_data.identification_provider_identifier
              }
            end
            {}
          end

          def supported_currencies
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              return vendor_identity_meta_data.currencies_supported
            end
            []
          end

          def refresh_vendor_meta_data
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              vendor(force_store_meta_data: true)
              return vendor_identity_meta_data
            end
            []
          end

          # Bank Accounts
          def bank_accounts
            return [] if not ::Showoff::Payments.configuration.managed_accounts_enabled
            bank_accounts = []

            vendor.external_accounts.all(object: 'bank_account').auto_paging_each do |bank_account|
              bank_accounts << ::Showoff::Payments::Providers::BankAccounts::Stripe.new(bank_account)
            end

            bank_accounts
          end

          def add_bank_account(bank_account_token)
            return [] if not ::Showoff::Payments.configuration.managed_accounts_enabled

            vendor.external_accounts.create(external_account: bank_account_token)
            bank_accounts
          end

          def remove_bank_account(bank_account_token)
            return [] if not ::Showoff::Payments.configuration.managed_accounts_enabled
            vendor.external_accounts.retrieve(bank_account_token).delete
            bank_accounts
          end

          def make_bank_account_default(bank_account_token)
            return [] if not ::Showoff::Payments.configuration.managed_accounts_enabled

            bank_account = vendor.external_accounts.retrieve(bank_account_token)
            bank_account.default_for_currency = true
            bank_account.save

            bank_accounts
          end


          private
          def stripe_account
            { stripe_account: provider_identifier }
          end


          def stripe_customer(customer_identity)
            if ::Showoff::Payments.configuration.managed_accounts_enabled
              external_customer_service.retrieve(customer_identity.provider_identifier)
            else
              external_customer_service.retrieve(customer_identity.provider_identifier, stripe_account)
            end
          end

          def external_charge_service
            ::Stripe::Charge
          end

          def external_customer_service
            ::Stripe::Customer
          end

          def external_refund_service
            ::Stripe::Refund
          end

          def external_file_service
            ::Stripe::FileUpload
          end

          def ensure_vendor_meta_data
            #TODO: Add refresh Interval from configuration in here
            #NOTE:
            # The refresh interval here will allow for the Stripe::Account associated
            # with this vendor to be refreshed from Stripe's API. This allows for the details
            # to be updated periodically without explicitly calling 'refresh_vendor_meta_data'
            # from the source application uisng the gem. This is a workaround until we integrate
            # webhooks into the gem
            if @vendor_identity.meta_data.blank?
              refresh_vendor_meta_data
            end
          end

          def vendor_identity_meta_data
            ensure_vendor_meta_data
            @vendor_identity.meta_data
          end

          def validate_supported_currency(currency)
            supported_currencies.include? currency.downcase
          end

          def update_meta_data(provider_vendor)
            # get meta data object
            @vendor_identity.create_meta_data if @vendor_identity.meta_data.blank?

            # get data from provider
            country = provider_vendor.country if provider_vendor.respond_to? :country
            default_currency = provider_vendor.default_currency if provider_vendor.respond_to? :default_currency
            currencies_supported = provider_vendor.currencies_supported if provider_vendor.respond_to? :currencies_supported

            payments_charges_enabled = provider_vendor.charges_enabled if provider_vendor.respond_to? :charges_enabled
            payments_charges_enabled = true if payments_charges_enabled.blank?

            payments_transfers_enabled = provider_vendor.transfers_enabled if provider_vendor.respond_to? :transfers_enabled
            payments_transfers_enabled = true if payments_transfers_enabled.blank?

            identification_status = Showoff::Payments::Vendors::IdentityMetaData.identification_statuses[provider_vendor.legal_entity.verification.status.to_sym]
            identification_details = provider_vendor.legal_entity.verification.details
            identification_details_code = provider_vendor.legal_entity.verification.details_code
            identification_provider_identifier =  provider_vendor.legal_entity.verification.document


            verification_fields_required = provider_vendor.verification.fields_needed
            verification_fields_disabled_reason = provider_vendor.verification.disabled_reason.gsub!('.','_') if provider_vendor.verification.disabled_reason.present?
            verification_fields_required_by = Time.at(provider_vendor.verification.due_by.to_i) if provider_vendor.verification.due_by.present?

            #update values
            @vendor_identity.meta_data.update_attributes(
                country: country,
                default_currency: default_currency,
                currencies_supported: currencies_supported,

                payments_charges_enabled: payments_charges_enabled,
                payments_transfers_enabled: payments_transfers_enabled,

                identification_status: identification_status,
                identification_details: identification_details,
                identification_details_code: identification_details_code,
                identification_provider_identifier: identification_provider_identifier,

                verification_fields_required: verification_fields_required,
                verification_fields_disabled_reason: verification_fields_disabled_reason,
                verification_fields_required_by: verification_fields_required_by
            )

            @vendor_identity.meta_data
          end

          def create_customer(customer, source = nil)
            details_hash = {
                email: customer.email,
                source: source
            }

            if customer.respond_to? :customerable_meta_data
              details_hash = details_hash.merge({metadata: customer.customerable_meta_data})
            end

            if ::Showoff::Payments.configuration.managed_accounts_enabled
              stripe_customer = external_customer_service.create(details_hash)
            else
              stripe_customer = external_customer_service.create(details_hash, stripe_account)
            end
            ::Showoff::Payments::Providers::Customers::Stripe.new(stripe_customer)

          end

          def self.provider
            Showoff::Payments::Provider.find_by(name: Provider.names['stripe'])
          end

          def self.create_vendor(vendor)
            stripe_vendor = external_account_service.create({
                                                                email: vendor.email
                                                            })
            stripe_vendor
          end

          def self.create_managed_vendor(vendor)

            vendor_data_hash = {
                type: :custom
            }
            if vendor.respond_to? :vendor_data
              vendor_data_hash = vendor_data_hash.merge(vendor.vendor_data)
            end

            validate_vendor_data(vendor_data_hash)

            stripe_vendor = external_account_service.create(vendor_data_hash)
            stripe_vendor
          end

          def self.external_account_service
            ::Stripe::Account
          end

          def self.validate_vendor_data(data)
            raise Showoff::Payments::Errors::VendorDataMissingError, I18n.t('payments.vendors.missing_managed_vendor_data', field: 'country') if data[:country].blank?
            raise Showoff::Payments::Errors::VendorDataMissingError, I18n.t('payments.vendors.missing_managed_vendor_data', field: 'email') if data[:email].blank?
            raise Showoff::Payments::Errors::VendorDataMissingError, I18n.t('payments.vendors.missing_managed_vendor_data', field: 'tos_acceptance') if data[:tos_acceptance].blank?
            raise Showoff::Payments::Errors::VendorDataMissingError, I18n.t('payments.vendors.missing_managed_vendor_data', field: 'tos_acceptance[ip]') if data[:tos_acceptance][:ip].blank?
            raise Showoff::Payments::Errors::VendorDataMissingError, I18n.t('payments.vendors.missing_managed_vendor_data', field: 'tos_acceptance[date]') if data[:tos_acceptance][:date].blank?
          end

          private
          # vendor update helpers
          def update_legal_entity(account, data)
            if @vendor_identity&.meta_data&.identification_provider_identifier || @vendor_identity&.meta_data&.verified?
              data.delete(:identification)
            end

            if @vendor_identity&.meta_data && !@vendor_identity.meta_data.verified?
              account.legal_entity.update_attributes(data)
            end
          end

          def try_verify_identity(account, identification)
            if identification && (@vendor_identity.meta_data.blank? || !@vendor_identity.meta_data.identification_provider_identifier || @vendor_identity.meta_data.unverified?)
              identification_url = identification[:url]
              identification_number = identification[:number]

              if identification_url
                begin
                  download_identification_file(url: identification_url, original_filename: "#{account.id}_identificiation.png") do |tmp_file|
                    file_upload = external_file_service.create(
                        {
                            purpose: 'identity_document',
                            file: tmp_file
                        },
                        stripe_account
                    )
                    if file_upload.present?
                      account.legal_entity.verification.document = file_upload.id
                    else
                      raise StandardError
                    end
                  end
                rescue StandardError
                  raise Showoff::Payments::Errors::VendorIdentificationError, I18n.t('payments.vendors.vendor_identification_error')
                end
              end

              if identification_number
                account.legal_entity.personal_id_number = identification_number
              end
            end
          end

          # temp files
          def puller
            @puller ||= ->(url){ Net::HTTP.get(URI.parse(url)) }
          end

          def pull_tempfile(original_filename:, url:)
            _generated_name = Pathname.new(original_filename)
            extension     = _generated_name.extname.to_s
            tmp_file_name = _generated_name.basename(extension).to_s

            file = Tempfile.new([tmp_file_name, extension])
            file.binmode
            file.write(puller.call(url))
            file.close
            file
          end

          def download_identification_file(original_filename:, url:)
            file = pull_tempfile(original_filename: original_filename, url: url)

            yield file.open
          ensure
            file && file.unlink
          end

        end
      end
    end
  end
end
