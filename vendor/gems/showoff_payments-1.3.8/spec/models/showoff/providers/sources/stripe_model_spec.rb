require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Sources::Stripe do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:stripe_customer) { Stripe::Customer.create(email: customer.email) }
  let(:object) { stripe_customer.sources.create(source: stripe_helper.generate_card_token) }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Sources::NotImplementedError }
  let(:expected_attributes) do
    [:id, :address_city, :address_country, :address_line1, :address_line2, :address_line1_check,
     :address_state, :address_zip, :address_zip_check, :brand, :country, :customer,
     :cvc_check, :exp_month, :exp_year, :fingerprint, :funding, :last4, :name]
  end

  subject { base }

  before { StripeMock.start }
  after { StripeMock.stop }

  # stripe ruby mock doesn't support refund API, so can't test properly yet

  it_behaves_like :a_stripe_object
end
