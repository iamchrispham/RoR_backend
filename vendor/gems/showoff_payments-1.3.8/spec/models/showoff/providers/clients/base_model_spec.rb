require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Clients::Base do
  let(:vendor_identity) { FactoryGirl.create(:vendor_identity) }
  let(:base) { described_class.new(vendor_identity) }
  let(:error_class) { Showoff::Payments::Providers::Clients::NotImplementedError }

  subject { base }

  context 'attributes' do
    it 'vendor identity' do
      expect(subject.vendor_identity.id).to eq(vendor_identity.id)
    end

    it 'vendor' do
      expect(subject.vendor.id).to eq(vendor_identity.vendor.id)
    end
  end

  context 'abstract methods raise not implemented error' do
    context 'instance methods' do
      it 'charge' do
        expect do
          subject.charge(customer_identity: nil, amount: nil, purchase: nil, currency: nil, application_fee: nil)
        end.to raise_error(error_class)
      end

      it 'sources' do
        expect { subject.sources(nil) }.to raise_error(error_class)
      end

      it 'add source' do
        expect { subject.add_source(nil, nil) }.to raise_error(error_class)
      end

      it 'remove source' do
        expect { subject.remove_source(nil, nil) }.to raise_error(error_class)
      end

      it 'make default' do
        expect { subject.make_default(nil, nil) }.to raise_error(error_class)
      end

      it 'create customer identity' do
        expect { subject.create_customer_identity(nil, nil) }.to raise_error(error_class)
      end

      it 'customer' do
        expect { subject.customer(nil) }.to raise_error(error_class)
      end
    end

    context 'class methods' do
      it 'create vendor identity' do
        expect { described_class.create_vendor_identity(nil) }.to raise_error(error_class)
      end
    end
  end
end
