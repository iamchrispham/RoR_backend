module Showoff
  module Payments
    module Vendors
      class Identity < ActiveRecord::Base
        self.table_name = :showoff_payments_vendor_identities

        belongs_to :vendor, polymorphic: true
        belongs_to :provider, class_name: 'Showoff::Payments::Provider'

        enum vendor_identity_type: [:stand_alone, :managed]

        has_many :receipts, -> { uniq! }, class_name: 'Showoff::Payments::Receipt', foreign_key: :vendor_identity_id
        has_many :refunds, -> { uniq! }, through: :receipts

        has_many :customer_identities, class_name: 'Showoff::Payments::Customers::Identity', foreign_key: :vendor_identity_id
        has_many :customers, -> { uniq! }, through: :customer_identities

        has_one :meta_data, class_name: 'Showoff::Payments::Vendors::IdentityMetaData', foreign_key: :vendor_identity_id

        validates :vendor, :provider, :provider_identifier, presence: true
        validates :provider_identifier, length: { minimum: 1 }
        validates :active, inclusion: { in: [ true, false ] }

        scope :active, -> { where(active: true) }
        scope :provider_identities, -> (name) { joins(:provider).where(showoff_payments_providers: { name: Showoff::Payments::Provider.names[name.to_s] }) }

        #managed account validation
        validates :provider_secret, :provider_key, presence: true, if: :managed_account?

        def managed_account?
          ::Showoff::Payments.configuration.managed_accounts_enabled
        end
      end
    end
  end
end
