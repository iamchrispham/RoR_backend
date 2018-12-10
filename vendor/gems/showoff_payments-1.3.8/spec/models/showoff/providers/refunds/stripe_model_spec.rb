require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Refunds::Stripe do
  let(:object) { Object.new }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Refunds::NotImplementedError }
  let(:expected_attributes) do
    [:id, :amount, :amount_refunded, :balance_transaction, :charge, :created, :currency,
     :description, :metadata, :reason, :receipt_number, :status]
  end

  subject { base }

  # stripe ruby mock doesn't support refund API, so can't test properly yet

  it_behaves_like :a_base_object
end
