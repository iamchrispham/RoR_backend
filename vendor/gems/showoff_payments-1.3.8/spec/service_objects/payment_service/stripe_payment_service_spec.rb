require 'rails_helper'

# TODO: Test zero'd purchases and refunds.
# TODO: Test credits

RSpec.describe Showoff::Payments::Services::PaymentService do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:purchase) { FactoryGirl.create(:purchase) }
  let(:provider) { FactoryGirl.create(:provider) }
  let(:provider_name) { :stripe }
  let(:payment_service_with_customer) { described_class.new(provider: provider_name, vendor: vendor, customer: customer) }
  let(:payment_service_vendor) { described_class.new(provider: provider_name, vendor: vendor) }

  let(:charge_params) { { amount: 1000, purchase: purchase, currency: 'EUR', application_fee: 10 } }
  let(:refund_params) { { receipt: stripe_charge, amount: 10, application_fee: 0 } }

  let(:missing_customer_error) { Showoff::Payments::Errors::CustomerMissingError }

  let(:stripe_account) { { stripe_account: subject.vendor_identity.provider_identifier } }
  let(:stripe_charge) { Stripe::Charge.create({ amount: 1000, application_fee: 100, currency: 'EUR', source: stripe_helper.generate_card_token }, stripe_account) }
  let(:service_charge) { subject.charge(charge_params) }

  let(:stripe_receipt_class) { Showoff::Payments::Receipt }
  let(:stripe_refund_class) { Showoff::Payments::Refund }
  let(:stripe_client_class) { Showoff::Payments::Providers::Clients::Stripe }

  let(:card) { subject.add_source(card_token).first }
  let(:card_token) { stripe_helper.generate_card_token }
  let(:default_card) { subject.make_source_default(card.id) }
  let(:sources) { subject.sources }

  let(:charge_specific_params) { { amount: 1000, purchase: purchase, currency: 'EUR', application_fee: 10, source: card } }


  before { StripeMock.start }
  after { StripeMock.stop }
  before(:each) { provider }

  context 'vendor identity' do
    subject { payment_service_with_customer }

    context 'without identity' do
      it 'creates vendor identity' do
        expect do
          subject.vendor_identity
        end.to change { Showoff::Payments::Vendors::Identity.count }.by(1)
      end

      it 'adds identity to vendor' do
        expect do
          subject.vendor_identity
        end.to change { vendor.vendor_identities.count }.by(1)
      end
    end
  end

  context 'without customer' do
    subject { payment_service_vendor }

    it 'has vendor' do
      expect(subject.vendor).to eq(vendor)
    end

    it 'has no customer' do
      expect(subject.customer).to be(nil)
    end

    it 'has no customer identity' do
      expect(subject.customer_identity).to be(nil)
    end

    it 'has stripe provider' do
      expect(subject.provider).to eq(:stripe)
    end

    context 'charges' do
      it 'is an array' do
        expect(subject.charges).to be_a(ActiveRecord::Relation)
      end

      it 'has no charges' do
        expect(subject.charges.length).to be(0)
      end
    end

    it 'charge' do
      expect { subject.charge(charge_params) }.to raise_error(missing_customer_error)
    end

    context 'refund' do
      pending 'is a stripe refund' do
        expect(subject.refund(refund_params)).to be_a(stripe_refund_class)
      end

      pending 'creates refund' do # can't test due to lack of refund support in stripe ruby mock
        expect do
          subject.refund(refund_params)
        end.to change { Showoff::Payments::Refund.count }.by(1)
      end

      pending 'adds vendor refund' do # can't test due to lack of refund support in stripe ruby mock
        expect do
          subject.refund(refund_params)
        end.to change { vendor.refunds.count }.by 1
      end

      pending 'attempts to create Stripe::Refund' do # can't test due to lack of refund support in stripe ruby mock
        expect(::Stripe::Refund).to receive(:create).with({
                                                            refund_application_fee: refund_params[:application_fee],
                                                            charge: refund_params[:receipt].id,
                                                            amount: refund_params[:amount]
                                                          }, stripe_account)
        subject.refund(refund_params)
      end
    end

    it 'add source' do
      expect { subject.add_source(card_token) }.to raise_error(missing_customer_error)
    end

    it 'remove source' do
      expect { subject.remove_source(card_token) }.to raise_error(missing_customer_error)
    end

    it 'make default' do
      expect { subject.make_source_default(card_token) }.to raise_error(missing_customer_error)
    end
  end

  context 'with customer' do
    subject { payment_service_with_customer }

    it 'has vendor' do
      expect(subject.vendor).to eq(vendor)
    end

    it 'has customer' do
      expect(subject.customer).to eq(customer)
    end

    context 'charges' do
      context 'create charge' do
        it 'creates receipt' do
          receipt = subject.charge(charge_params)

          expect(receipt).to be_a(Showoff::Payments::Receipt)
        end

        it 'creates receipt with source' do
          receipt = subject.charge(charge_specific_params)

          expect(receipt).to be_a(Showoff::Payments::Receipt)
          expect(receipt.source).to eq(card)
        end

        it 'charges correct amount' do
          receipt = subject.charge(charge_params)

          expect(receipt.amount).to eq(charge_params[:amount])
        end

        it 'sets application fee' do
          receipt = subject.charge(charge_params)

          expect(receipt.application_fee).to eq(charge_params[:application_fee])
        end

        it 'persists receipt' do
          expect do
            subject.charge(charge_params)
          end.to change { Showoff::Payments::Receipt.count }.by(1)
        end

        it 'adds receipt to customer' do
          expect do
            subject.charge(charge_params)
          end.to change { customer.receipts.count }.by(1)
        end

        it 'adds receipt to vendor' do
          expect do
            subject.charge(charge_params)
          end.to change { vendor.receipts.count }.by(1)
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
            expect(subject.charges).to be_a(ActiveRecord::Associations::CollectionProxy)
          end

          context 'has no receipts' do
            it 'for customer identity' do
              expect(subject.charges.length).to be(0)
            end
          end
        end

        context 'with charges' do
          before(:each) { service_charge }

          let(:customer_receipts) { subject.charges }

          it 'is array' do
            expect(subject.charges).to be_a(ActiveRecord::Associations::CollectionProxy)
          end

          context 'customer identity' do
            it 'has correct charges' do
              expect(customer_receipts.length).to be(1)

              first_receipt = customer_receipts.first

              expect(first_receipt.id).to eq(service_charge.id)
            end

            it 'contains receipts' do
              customer_receipts.each do |receipt|
                expect(receipt).to be_a(Showoff::Payments::Receipt)
              end
            end
          end
        end
      end
    end

    context 'refunds' do
      context 'create refund' do
        pending 'is a stripe refund' do # can't test due to lack of refund support in stripe ruby mock
          expect(subject.refund(refund_params)).to be_a(stripe_refund_class)
        end

        pending 'creates refund' do # can't test due to lack of refund support in stripe ruby mock
          expect do
            subject.refund(refund_params)
          end.to change { Showoff::Payments::Refund.count }.by(1)
        end

        pending 'adds vendor refund' do # can't test due to lack of refund support in stripe ruby mock
          expect do
            subject.refund(refund_params)
          end.to change { vendor.refunds.count }.by 1
        end

        pending 'attempts to create Stripe::Refund' do  # can't test due to lack of refund support in stripe ruby mock
          expect(::Stripe::Refund).to receive(:create).with({
                                                              refund_application_fee: refund_params[:application_fee],
                                                              charge: refund_params[:receipt].id,
                                                              amount: refund_params[:amount]
                                                            }, stripe_account)
          subject.refund(refund_params)
        end

        pending 'creates refund using receipt model' do # can't test due to lack of refund support in stripe ruby mock
          service_charge
          refund_params[:receipt] = Showoff::Payments::Receipt.last
          expect(::Stripe::Refund).to receive(:create).with({
                                                              refund_application_fee: refund_params[:application_fee],
                                                              charge: refund_params[:receipt].provider_identifier,
                                                              amount: refund_params[:amount]
                                                            }, stripe_account: subject.vendor_identity.provider_identifier)
          subject.refund(refund_params)
        end
      end
    end

    context 'sources' do
      context 'add source' do
        it 'adds to customer identity' do
          expect { card }.to change { subject.sources.length }.by(1)
        end

        it 'is first source' do
          subject.add_source(stripe_helper.generate_card_token).first
          card

          first_source = sources.first
          expect(first_source.id).to eq(card.id)
        end
      end

      context 'create source' do
        it 'adds to customer identity' do
          expect { card }.to change { subject.sources.length }.by(1)
        end

        it 'is first source' do
          subject.add_source(stripe_helper.generate_card_token)
          card

          first_source = sources.first
          expect(first_source.id).to eq(card.id)
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
      end

      context 'remove source' do
        before(:each) { card }

        it 'removes from customer identity' do
          expect { subject.remove_source(card.id) }.to change { subject.sources.length }.by(-1)
        end

        it 'removes source' do
          subject.remove_source(card.id)

          expect(subject.sources.length).to eq(0)
        end
      end

      context 'get sources' do
        it 'with no sources' do
          sources = subject.sources

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
    end
  end
end
