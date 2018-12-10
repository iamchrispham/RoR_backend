require 'rails_helper'

RSpec.describe Showoff::Payments::Refund, type: :model do
  let(:refund) { FactoryGirl.create(:refund) }

  subject { refund }

  it { should belong_to(:receipt) }

  it { should have_one(:vendor_identity) }
  it { should have_one(:customer_identity) }
  it { should have_one(:provider) }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:provider_identifier) }

  it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }

  it { should delegate_method(:currency).to(:receipt) }
  it { should delegate_method(:purchase).to(:receipt) }
  it { should delegate_method(:vendor).to(:vendor_identity) }
  it { should delegate_method(:customer).to(:customer_identity) }

  it 'updates receipt on save' do
    expect_any_instance_of(Showoff::Payments::Refund).to receive(:update_receipt_status).at_least(:once)

    subject.update_attributes(updated_at: Time.now)
  end
end
