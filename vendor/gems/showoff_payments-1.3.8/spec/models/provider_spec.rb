require 'rails_helper'

RSpec.describe Showoff::Payments::Provider, type: :model do
  let(:provider) { FactoryGirl.create(:provider) }

  subject { provider }

  it { should define_enum_for(:name).with([:stripe]) }

  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:name) }

  it { should validate_uniqueness_of(:slug) }

  it { should have_many(:vendor_identities) }

  it { should respond_to(:client) }

  context 'provider client' do
    subject { provider.client }

    it { should eq(Showoff::Payments::Providers::Clients::Stripe) }
  end
end
