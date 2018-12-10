require 'rails_helper'

RSpec.describe Showoff::Payments::Source, type: :model do
  let(:source) { FactoryGirl.create(:source) }

  subject { source }

  it { should belong_to(:customer_identity) }

  it { should belong_to(:vendor_identity) }
  it { should have_one(:provider) }

  it { should have_many(:receipts) }
  it { should have_many(:refunds) }

  it { should validate_presence_of(:last_four) }
  it { should validate_presence_of(:provider_identifier) }
  it { should validate_presence_of(:exp_month) }
  it { should validate_presence_of(:exp_year) }
  it { should validate_presence_of(:customer_identity) }

  it { should validate_length_of(:provider_identifier).is_at_least(1) }

  it { should delegate_method(:customer).to(:customer_identity) }
  it { should delegate_method(:vendor).to(:vendor_identity) }
end
