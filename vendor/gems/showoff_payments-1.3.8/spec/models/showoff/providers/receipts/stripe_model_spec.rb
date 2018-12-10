require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Receipts::Stripe do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:object) { Stripe::Charge.create(amount: 1000, application_fee: 100, currency: 'EUR', source: stripe_helper.generate_card_token) }
  let(:stripe_receipt) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Receipts::NotImplementedError }
  let(:expected_attributes) do
    [:id, :amount, :amount_refunded, :application_fee, :balance_transaction, :captured, :created, :currency,
     :customer, :description, :destination, :dispute, :failure_code, :failure_message, :fraud_details, :invoice,
     :livemode, :metadata, :paid, :receipt_email, :receipt_number, :refunded, :refunds, :shipping, :source,
     :statement_descriptor, :status]
  end

  subject { stripe_receipt }

  before { StripeMock.start }
  after { StripeMock.stop }

  it_behaves_like :a_stripe_object
end
