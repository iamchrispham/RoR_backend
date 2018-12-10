module Showoff
  module Payments
    module Customers
      class Identity < ActiveRecord::Base
        self.table_name = :showoff_payments_customer_identities

        belongs_to :customer, polymorphic: true
        belongs_to :vendor_identity, class_name: 'Showoff::Payments::Vendors::Identity'

        belongs_to :provider, class_name: 'Showoff::Payments::Provider'

        has_many :receipts, -> { uniq! }, class_name: 'Showoff::Payments::Receipt', foreign_key: :customer_identity_id
        has_many :refunds, -> { uniq! }, through: :receipts

        has_many :sources, -> { uniq! }, class_name: 'Showoff::Payments::Source', foreign_key: :customer_identity_id

        validates :customer, :provider, :provider_identifier, presence: true
        validates :provider_identifier, length: { minimum: 1 }
        validates :active, inclusion: { in: [ true, false ] }

        scope :active, -> { where(active: true) }
        scope :provider_identities, -> (name) { joins(:provider).where(showoff_payments_providers: { name: Showoff::Payments::Provider.names[name.to_s] }) }
      end
    end
  end
end
