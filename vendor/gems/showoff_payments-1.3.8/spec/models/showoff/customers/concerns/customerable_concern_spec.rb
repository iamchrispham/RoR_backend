require 'rails_helper'

class Customerable < ActiveRecord::Base
  has_no_table
  include Showoff::Payments::Customers::Customerable
end

RSpec.describe Customerable do
  let(:customerable) { described_class.new }

  subject { customerable }

  it { should have_many(:customer_identities) }
  it { should have_many(:vendor_identities) }
  it { should have_many(:providers) }
  it { should have_many(:receipts) }
  it { should have_many(:refunds) }
end
