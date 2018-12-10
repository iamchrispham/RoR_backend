require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Customers::Base do
  let(:object) { Object.new }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Customers::NotImplementedError }
  let(:expected_attributes) do
    [:id, :account_balance, :created, :currency, :default_source, :delinquent, :description, :discount, :email, :livemode, :sources, :subscriptions]
  end

  subject { base }

  it_behaves_like :a_base_object
end
