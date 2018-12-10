require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Receipts::Base do
  let(:object) { Object.new }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Receipts::NotImplementedError }
  let(:expected_attributes) do
    [:id, :amount, :amount_refunded, :application_fee, :balance_transaction, :captured, :created, :currency,
     :customer, :description, :destination, :dispute, :failure_code, :failure_message, :fraud_details, :invoice,
     :livemode, :metadata, :paid, :receipt_email, :receipt_number, :refunded, :refunds, :shipping, :source,
     :statement_descriptor, :status]
  end

  subject { base }

  it_behaves_like :a_base_object
end
