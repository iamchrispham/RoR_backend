module Showoff
  module Payments
    module Vendors
      class IdentityMetaData < ActiveRecord::Base
        self.table_name = :showoff_payments_vendor_identity_meta_datas

        serialize :verification_fields_required, JSON
        serialize :currencies_supported, JSON

        belongs_to :vendor_identity, class_name: 'Showoff::Payments::Vendors::Identity'

        enum identification_status: [:unverified, :pending, :verified]

        validates :vendor_identity, presence: true


      end
    end
  end
end
