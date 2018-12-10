module Showoff
  module Payments
    class Receipt < ActiveRecord::Base
      self.table_name = :showoff_payments_receipts

      enum status: [:processed, :partially_refunded, :fully_refunded, :cancelled, :fulfilled]

      belongs_to :customer_identity, class_name: 'Showoff::Payments::Customers::Identity', foreign_key: :customer_identity_id
      belongs_to :vendor_identity, class_name: 'Showoff::Payments::Vendors::Identity', foreign_key: :vendor_identity_id
      belongs_to :source, class_name: 'Showoff::Payments::Source', foreign_key: :source_id

      belongs_to :purchase, polymorphic: true
      belongs_to :address, polymorphic: true

      has_one :provider, through: :vendor_identity

      has_many :refunds, class_name: 'Showoff::Payments::Refund'
      has_many :receipt_vouchers, class_name: 'Showoff::Payments::ReceiptVoucher'

      delegate :customer, to: :customer_identity
      delegate :vendor, to: :vendor_identity

      validates :amount, :currency, :provider_identifier, :application_fee, :customer_identity, :purchase, :quantity, presence: true
      validates :amount, :application_fee, :quantity, :credits, numericality: { greater_than_or_equal_to: 0 }
      validates :currency, :provider_identifier, length: { minimum: 1 }

      def update_status
        refunded_total = refunds.sum(:amount)
        if refunded_total > 0
          self.status = :fully_refunded
          self.status = :partially_refunded if refunded_total < amount
          save
        end
      end
    end
  end
end
