require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Serializers::SourceSerializer do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:stripe_customer) { Stripe::Customer.create(email: customer.email) }
  let(:stripe_card) { stripe_customer.sources.create(source: stripe_helper.generate_card_token) }
  let(:object) { Showoff::Payments::Providers::Sources::Stripe.new(stripe_card) }

  subject { JSON.parse(serialized_resource(object, described_class).to_json) }

  before { StripeMock.start }
  after { StripeMock.stop }

  it 'serialized source' do
    expect(subject).to have_key('id')
    expect(subject).to have_key('brand')
    expect(subject).to have_key('country')
    expect(subject).to have_key('cvc_check')
    expect(subject).to have_key('exp_month')
    expect(subject).to have_key('exp_year')
    expect(subject).to have_key('last_four')

    id = subject['id']
    brand = subject['brand']
    country = subject['country']
    cvc_check = subject['cvc_check']
    exp_month = subject['exp_month']
    exp_year = subject['exp_year']
    last_four = subject['last_four']

    expect(id).to be_a(String)
    expect(brand).to be_a(String)
    expect(country).to be_a(String)
    expect(cvc_check).to be_a(String) unless cvc_check.nil?
    expect(exp_month).to be_a(Integer)
    expect(exp_year).to be_a(Integer)
    expect(last_four).to be_a(String)

    expect(id.length).to be > 0
    expect(brand.length).to be > 0
    expect(country.length).to be > 0
    expect(cvc_check.length).to be > 0 unless cvc_check.nil?
    expect(exp_month).to be >= 1
    expect(exp_month).to be <= 12

    expect(exp_year).to be >= 1980

    expect(last_four.length).to be > 0
  end
end
