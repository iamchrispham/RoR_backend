module Showoff
  module Payments
    module Customers
      module Customerable
        extend ActiveSupport::Concern

        included do
          has_many :customer_identities, class_name: 'Showoff::Payments::Customers::Identity', as: :customer

          has_many :vendor_identities, -> { uniq! }, through: :customer_identities
          has_many :vendors, -> { uniq! }, through: :customer_identities
          has_many :providers, -> { uniq! }, through: :customer_identities

          has_many :receipts, through: :customer_identities
          has_many :refunds, through: :receipts

          has_many :sources, through: :customer_identities
        end
      end
    end
  end
end
