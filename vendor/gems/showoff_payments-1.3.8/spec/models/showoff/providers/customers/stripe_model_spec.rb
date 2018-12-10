require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Customers::Stripe do
  let(:object) { Stripe::Customer.create(email: customer.email) }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Customers::NotImplementedError }
  let(:expected_attributes) do
    [:id, :account_balance, :created, :currency, :default_source, :delinquent, :description, :discount, :email, :livemode, :sources, :subscriptions]
  end
  let(:customer) { FactoryGirl.create(:customer) }

  subject { base }

  before { StripeMock.start }
  after { StripeMock.stop }

  it_behaves_like :a_stripe_object
end
