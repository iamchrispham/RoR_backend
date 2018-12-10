module Showoff
  module Payments
    module Services
      class PaymentService < Showoff::Services::Base

        attr_reader :provider, :vendor, :customer, :client

        include ::Showoff::Payments::Services::Concerns::BaseConcern
        include ::Showoff::Payments::Services::Concerns::Chargeable
        include ::Showoff::Payments::Services::Concerns::Refundable
        include ::Showoff::Payments::Services::Concerns::Customerable
        include ::Showoff::Payments::Services::Concerns::Vendorable

        def initialize(provider: nil, vendor: nil, customer: nil, vendor_identity: nil)
          @vendor = vendor
          @customer = customer
          @provider = provider || Showoff::Payments.configuration.provider
          @vendor_identity = vendor_identity
        end

        def vendor_identity
          return nil unless @vendor
          @vendor_identity ||= @vendor.vendor_identities.active.provider_identities(@provider).first
          @vendor_identity ||= client_class.create_vendor_identity(@vendor)
        rescue StandardError => e
          handle_error(e)
        end

        def customer_identity
          return nil unless @customer
          if ::Showoff::Payments.configuration.managed_accounts_enabled
            @customer_identity ||= Showoff::Payments::Customers::Identity.active.provider_identities(@provider).where(customer: @customer).first
          else
            @customer_identity ||= Showoff::Payments::Customers::Identity.active.provider_identities(@provider).where(customer: @customer, vendor_identity: vendor_identity).first
          end
          @customer_identity ||= client.create_customer_identity(@customer, provider_object)
        rescue StandardError => e
          handle_error(e)
        end

        def client
          raise ProviderMissingError, I18n.t('payments.providers.missing') if provider_object.blank?
          @client ||= provider_object.client.new(vendor_identity)
        rescue StandardError => e
          handle_error(e)
        end

        private

        def client_class
          return nil if @provider.blank?
          ('::Showoff::Payments::Providers::Clients::' + @provider.to_s.classify).constantize
        end

        def provider_object
          return nil if @provider.blank?
          @provider_object ||= Showoff::Payments::Provider.find_by(slug: @provider.to_s.downcase)
        end

        def provider_class
          return nil if @provider.blank?
          (@provider.to_s.classify).constantize
        end

        def ensure_customer
          raise CustomerMissingError, I18n.t('payments.customers.missing') unless @customer
        end

        def ensure_vendor
          raise VendorMissingError, I18n.t('payments.vendors.missing') unless @vendor
        end

        def create_source(source)
          source = customer_identity.sources.find_or_create_by(
              vendor_identity: vendor_identity,
              customer_identity: customer_identity,
              last_four: source.last_four,
              cvc_check: source.cvc_check,
              exp_month: source.exp_month,
              exp_year: source.exp_year,
              brand: source.brand,
              country: source.country,
              provider_identifier: source.id
          )
          source.active = true
          source.default = true if customer_identity.sources.count == 1

          source.save!
          source
        end

        def saved_sources_from_client_sources(sources)
          saved_sources = []
          sources.each do |source|
            saved_source = create_source(source)
            saved_sources << saved_source
          end
          saved_sources
        end

      end
    end
  end
end
