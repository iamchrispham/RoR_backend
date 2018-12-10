module Showoff
  module Payments
    class ReceiptVoucher < ActiveRecord::Base
      self.table_name = :showoff_payments_receipts_vouchers

      belongs_to :receipt, class_name: 'Showoff::Payments::Receipt'
      belongs_to :voucher, polymorphic: true
    end
  end
end
