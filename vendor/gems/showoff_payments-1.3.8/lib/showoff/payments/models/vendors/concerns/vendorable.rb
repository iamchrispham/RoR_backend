module Showoff
  module Payments
    module Vendors
      module Vendorable
        extend ActiveSupport::Concern

        included do
          has_many :vendor_identities, class_name: 'Showoff::Payments::Vendors::Identity', as: :vendor
          has_many :customer_identities, -> { uniq! }, through: :vendor_identities
          has_many :customers, -> { uniq! }, through: :vendor_identities

          has_many :providers, -> { uniq! }, through: :vendor_identities

          has_many :receipts, -> { uniq! }, through: :vendor_identities
          has_many :refunds, -> { uniq! }, through: :vendor_identities
        end
      end
    end
  end
end
