require 'rails_helper'

RSpec.describe Showoff::Payments::Vendors::Identity, type: :model do
  let(:identity) { FactoryGirl.create(:vendor_identity) }

  subject { identity }

  it { should validate_presence_of(:vendor) }
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:provider_identifier) }

  it { should validate_length_of(:provider_identifier).is_at_least(1) }

  it { should have_many(:customer_identities) }
  it { should have_many(:customers) }
  it { should have_many(:receipts) }
  it { should have_many(:refunds) }
end
