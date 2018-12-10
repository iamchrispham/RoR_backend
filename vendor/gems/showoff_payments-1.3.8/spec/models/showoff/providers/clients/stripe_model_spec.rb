require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Clients::Stripe do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:provider) { FactoryGirl.create(:provider) }
  let(:purchase) { FactoryGirl.create(:purchase) }
  let(:charge_params) { { customer_identity: customer_identity, amount: 1000, purchase: purchase, currency: 'EUR', application_fee: 10 } }
  let(:stripe_charge) { subject.charge(charge_params) }
  let(:refund_params) { { receipt: stripe_charge, application_fee: false, amount: 100 } }
  let(:card) { subject.add_source(customer_identity, stripe_helper.generate_card_token).first }
  let(:sources) { subject.sources(customer_identity) }
  let(:default_card) { subject.make_default(customer_identity, card.id) }

  let(:vendor_identity) do
    account = Stripe::Account.create(email: vendor.email)
    vendor_identity = vendor.vendor_identities.create(provider: provider, provider_identifier: account.id)
    vendor_identity
  end

  subject { described_class.new(vendor_identity) }

  let(:customer_identity) { subject.create_customer_identity(customer, provider) }

  before { StripeMock.start }
  after { StripeMock.stop }

  it 'creates a customer identity' do
    expect do
      subject.create_customer_identity(customer, provider)
    end.to change { Showoff::Payments::Customers::Identity.count }.by(1)
  end

  it 'adds customer identity to vendor' do
    if not ::Showoff::Payments.configuration.managed_accounts_enabled
      expect do
        subject.create_customer_identity(customer, provider)
      end.to change { vendor.customer_identities.count }.by(1)
    end
  end

  it 'adds vendor identity to vendor' do
    if not ::Showoff::Payments.configuration.managed_accounts_enabled
      expect do
        subject.create_customer_identity(customer, provider)
      end.to change { customer.vendor_identities.count }.by(1)
    end
  end

  it 'creates a stripe customer' do
    stripe_customer = subject.customer(customer_identity)
    expect(stripe_customer).to be_a(Showoff::Payments::Providers::Customers::Stripe)

    expect(stripe_customer.email).to eq(customer.email)
  end

  context 'vendor' do
    before(:each) { provider }

    it 'creates a vendor identity' do
      expect do
        described_class.create_vendor_identity(vendor)
      end.to change { Showoff::Payments::Vendors::Identity.count }.by(1)
    end

    it 'adds a vendor identity to vendor' do
      expect do
        described_class.create_vendor_identity(vendor)
      end.to change { vendor.vendor_identities.count }.by(1)
    end

    it 'creates a stripe vendor' do
      stripe_vendor = subject.vendor

      expect(stripe_vendor).to be_a(Showoff::Payments::Providers::Vendors::Stripe)
      expect(stripe_vendor.email).to eq(vendor.email)
    end
  end

  context 'create charges' do
    it 'creates receipt' do
      receipt = subject.charge(charge_params)

      expect(receipt).to be_a(Showoff::Payments::Providers::Receipts::Stripe)
    end

    it 'charges correct amount' do
      receipt = subject.charge(charge_params)

      expect(receipt.amount).to eq(charge_params[:amount])
    end

    it 'sets application fee' do
      receipt = subject.charge(charge_params)
      if not ::Showoff::Payments.configuration.managed_accounts_enabled
        expect(receipt.application_fee).to eq(charge_params[:application_fee])
      else
        expect(receipt.destination.amount).to eq(charge_params[:amount] - charge_params[:application_fee])
        expect(receipt.amount).to eq(charge_params[:amount])
      end
    end

    it 'allows nil application fee' do
      charge_params[:application_fee] = nil

      receipt = subject.charge(charge_params)

      expect(receipt.application_fee).to eq(charge_params[:application_fee])
    end
  end

  context 'get charges' do
    context 'without charges' do
      it 'is array' do
        expect(subject.charges).to be_a(Array)
      end

      context 'has no receipts' do
        it 'for customer identity' do
          expect(subject.charges(customer_identity).length).to be(0)
        end

        it 'for connected account' do
          expect(subject.charges.length).to be(0)
        end
      end
    end

    context 'with charges' do
      before(:each) { stripe_charge }

      let(:customer_receipts) { subject.charges(customer_identity) }
      let(:connected_account_receipts) { subject.charges }

      it 'is array' do
        expect(subject.charges).to be_a(Array)
      end

      context 'customer identity' do
        it 'has correct charges' do
          expect(customer_receipts.length).to be(1)

          first_receipt = customer_receipts.first

          expect(first_receipt.id).to eq(stripe_charge.id)
        end

        it 'contains receipts' do
          customer_receipts.each do |receipt|
            expect(receipt).to be_a(Showoff::Payments::Providers::Receipts::Stripe)
          end
        end
      end

      context 'connected account' do
        it 'has correct charges' do
          expect(connected_account_receipts.length).to be(1)

          first_receipt = connected_account_receipts.first

          expect(first_receipt.id).to eq(stripe_charge.id)
        end

        it 'contains receipts' do
          connected_account_receipts.each do |receipt|
            expect(receipt).to be_a(Showoff::Payments::Providers::Receipts::Stripe)
          end
        end
      end
    end
  end

  context 'create refunds' do
    # Cant fully test as stripe-ruby-mock doesn't support Refunds API
    it 'creates refund' do
      if not ::Showoff::Payments.configuration.managed_accounts_enabled
        expect(::Stripe::Refund).to receive(:create).with({
                                                              refund_application_fee: refund_params[:application_fee],
                                                              charge: refund_params[:receipt].id,
                                                              amount: refund_params[:amount]
                                                          }, stripe_account: subject.vendor_identity.provider_identifier)
        subject.refund(refund_params)
      end
    end
  end

  context 'get refunds' do
    # Cant fully test as stripe-ruby-mock doesn't support Refunds API
    it 'gets refunds' do
      refund = double('Refund', auto_paging_each: nil)
      expect(::Stripe::Refund).to receive(:list).with({}, stripe_account: subject.vendor_identity.provider_identifier).and_return(refund)
      subject.refunds
    end
  end

  context 'get sources' do
    it 'with no sources' do
      sources = subject.sources(customer_identity)

      expect(sources).to be_a(Array)
      expect(sources.length).to be(0)
    end

    context 'with sources' do
      before(:each) { card }

      it 'is an array' do
        expect(sources).to be_a(Array)
      end

      it 'has sources' do
        expect(sources.length).to be(1)
      end

      it 'has expected source' do
        first_source = sources.first
        expect(first_source.id).to eq(card.id)
      end
    end
  end

  context 'add source' do
    it 'adds to customer identity' do
      expect { card }.to change { subject.sources(customer_identity).length }.by(1)
    end

    it 'is first source' do
      subject.add_source(customer_identity, stripe_helper.generate_card_token)
      card

      first_source = sources.first
      expect(first_source.id).to eq(card.id)
    end
  end

  context 'remove source' do
    before(:each) { card }

    it 'removes from customer identity' do
      expect { subject.remove_source(customer_identity, card.id) }.to change { subject.sources(customer_identity).length }.by(-1)
    end

    it 'removes source' do
      subject.remove_source(customer_identity, card.id)

      expect(subject.sources(customer_identity).length).to eq(0)
    end
  end

  context 'make default' do
    before(:each) { default_card }
    it 'is array' do
      expect(default_card).to be_a(Array)
    end

    it 'has card' do
      expect(default_card.length).to be(1)
    end

    it 'has default card' do
      first_card = default_card.first

      expect(first_card.id).to eq(card.id)
    end

    it 'sets default for customer' do
      expect(subject.customer(customer_identity).default_source).to eq(card.id)
    end
  end
end
