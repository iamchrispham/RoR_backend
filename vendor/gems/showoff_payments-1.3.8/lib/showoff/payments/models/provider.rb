module Showoff
  module Payments
    class Provider < ActiveRecord::Base
      self.table_name = :showoff_payments_providers

      enum name: [:stripe]

      has_many :vendor_identities, class_name: 'Showoff::Payments::Vendors::Identity'

      validates :name, :slug, presence: true, uniqueness: true, length: { minimum: 1 }

      def client
        ('::Showoff::Payments::Providers::Clients::' + name.to_s.classify).constantize
      end
    end
  end
end
