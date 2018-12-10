require 'rails_helper'

RSpec.describe Showoff::Payments::Customers::Identity, type: :model do
  let(:identity) { FactoryGirl.create(:customer_identity) }

  subject { identity }

  it { should validate_presence_of(:customer) }
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:provider_identifier) }

  it { should validate_length_of(:provider_identifier).is_at_least(1) }

  it { should belong_to(:provider) }
  it { should have_many(:receipts) }
  it { should have_many(:refunds) }
end
