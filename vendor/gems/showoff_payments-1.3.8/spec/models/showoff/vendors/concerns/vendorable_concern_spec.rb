require 'rails_helper'

class Vendorable < ActiveRecord::Base
  has_no_table
  include Showoff::Payments::Vendors::Vendorable
end

RSpec.describe Vendorable do
  let(:vendorable) { described_class.new }

  subject { vendorable }

  it { should have_many(:vendor_identities) }
  it { should have_many(:customer_identities) }
  it { should have_many(:providers) }
  it { should have_many(:receipts) }
  it { should have_many(:refunds) }
end
