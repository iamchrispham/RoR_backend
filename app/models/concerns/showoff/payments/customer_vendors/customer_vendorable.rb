module Showoff
  module Payments
    module CustomerVendors
      module CustomerVendorable
        extend ActiveSupport::Concern

        included do
          has_many :customer_identities, class_name: 'Showoff::Payments::Customers::Identity', as: :customer
          has_many :sources, through: :customer_identities

          has_many :purchased_from_vendor_identities, -> { uniq! }, through: :customer_identities, source: :vendor_identity

          has_many :vendor_identities, class_name: 'Showoff::Payments::Vendors::Identity', as: :vendor
          has_many :sold_to_customer_identities, -> { uniq! }, through: :vendor_identities, source: :customer_identities

          has_many :providers, -> { uniq! }, through: :customer_identities

          has_many :customer_receipts, through: :customer_identities, source: :receipts
          has_many :customer_refunds, through: :customer_receipts, source: :refunds

          has_many :vendor_receipts, -> { uniq! }, through: :vendor_identities, source: :receipts
          has_many :vendor_refunds, -> { uniq! }, through: :vendor_receipts, source: :refunds
        end
      end
    end
  end
end
