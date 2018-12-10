module Showoff
  module Payments
    class Refund < ActiveRecord::Base
      self.table_name = :showoff_payments_refunds

      belongs_to :receipt, class_name: 'Showoff::Payments::Receipt', foreign_key: :receipt_id

      has_one :customer_identity, through: :receipt
      has_one :vendor_identity, through: :customer_identity
      has_one :provider, through: :vendor_identity

      validates :amount, :provider_identifier, presence: true
      validates :amount, numericality: { greater_than_or_equal_to: 0 }

      delegate :currency, to: :receipt
      delegate :purchase, to: :receipt
      delegate :vendor, to: :vendor_identity
      delegate :customer, to: :customer_identity

      after_save :update_receipt_status

      private

      def update_receipt_status
        receipt.update_status
      end
    end
  end
end
