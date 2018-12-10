module Showoff
  module Payments
    class Source < ActiveRecord::Base
      self.table_name = :showoff_payments_sources

      belongs_to :customer_identity, class_name: 'Showoff::Payments::Customers::Identity', foreign_key: :customer_identity_id
      belongs_to :vendor_identity, class_name: 'Showoff::Payments::Vendors::Identity', foreign_key: :vendor_identity_id
      has_one :provider, through: :vendor_identity

      has_many :receipts, class_name: 'Showoff::Payments::Receipt'
      has_many :refunds, class_name: 'Showoff::Payments::Refund', through: :receipts

      delegate :customer, to: :customer_identity
      delegate :vendor, to: :vendor_identity

      validates :brand, :country, :exp_month, :exp_year, :last_four, :provider_identifier, :customer_identity, presence: true
      validates :provider_identifier, length: { minimum: 1 }
      validates :active, inclusion: { in: [ true, false ] }

      scope :active, -> { where(active: true) }
      scope :default, -> { where(default: true) }
    end
  end
end
