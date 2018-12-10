module Showoff
  module Payments
    module Services
      module Concerns
        module Chargeable
          extend Showoff::Payments::Services::Concerns::BaseConcern

          def charge(amount:, purchase:, currency:, application_fee:, quantity: 1, notes: nil, vouchers: nil, credits: 0, source: nil)
            raise PurchaseMissingError, I18n.t('payments.purchases.missing') if purchase.blank?

            ensure_customer

            provider_identifier = :zero_charge
            unless amount.zero?
              receipt = client.charge(customer_identity: customer_identity,
                                      amount: amount,
                                      purchase: purchase,
                                      currency: currency,
                                      application_fee: application_fee,
                                      source: source
              )
              provider_identifier = receipt.id
            end

            receipt_record = Showoff::Payments::Receipt.create(purchase: purchase,
                                                               currency: currency,
                                                               application_fee: application_fee,
                                                               amount: amount,
                                                               provider_identifier: provider_identifier,
                                                               customer_identity: customer_identity,
                                                               vendor_identity: vendor_identity,
                                                               quantity: quantity,
                                                               notes: notes,
                                                               credits: credits,
                                                               source: source
            )

            if vouchers
              vouchers = [vouchers] unless vouchers.respond_to?(:length)
              vouchers.each do |voucher|
                receipt_record.receipt_vouchers.create(voucher: voucher)
              end
            end
            receipt_record
          rescue StandardError => e
            handle_error(e)
          end

          def charges
            customer_identity ? customer_identity.receipts : Showoff::Payments::Receipt.none
          rescue StandardError => e
            handle_error(e)
          end
        end
      end
    end
  end
end
