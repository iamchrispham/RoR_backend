require 'rails_helper'

RSpec.describe Showoff::Payments::Receipt, type: :model do
  let(:receipt) { FactoryGirl.create(:receipt) }

  subject { receipt }

  it { should define_enum_for(:status).with([:processed, :partially_refunded, :fully_refunded, :cancelled, :fulfilled]) }

  it { should belong_to(:customer_identity) }
  it { should belong_to(:purchase) }

  it { should belong_to(:vendor_identity) }
  it { should have_one(:provider) }

  it { should have_many(:refunds) }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:provider_identifier) }
  it { should validate_presence_of(:application_fee) }
  it { should validate_presence_of(:customer_identity) }
  it { should validate_presence_of(:purchase) }
  it { should validate_presence_of(:quantity) }

  it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:application_fee).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:credits).is_greater_than_or_equal_to(0) }

  it { should validate_length_of(:currency).is_at_least(1) }
  it { should validate_length_of(:provider_identifier).is_at_least(1) }

  it { should delegate_method(:customer).to(:customer_identity) }
  it { should delegate_method(:vendor).to(:vendor_identity) }
end
