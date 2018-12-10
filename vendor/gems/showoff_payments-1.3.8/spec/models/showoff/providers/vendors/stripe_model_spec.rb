require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Vendors::Stripe do
  let(:object) { Stripe::Account.create(email: vendor.email) }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Vendors::NotImplementedError }
  let(:expected_attributes) do
    [:id, :business_name, :business_url, :charges_enabled, :country, :default_currency, :details_submitted,
     :display_name, :email, :managed, :statement_descriptor, :support_phone, :timezone, :transfers_enabled]
  end
  let(:vendor) { FactoryGirl.create(:vendor) }

  subject { base }

  before { StripeMock.start }
  after { StripeMock.stop }

  it_behaves_like :a_stripe_object
end
