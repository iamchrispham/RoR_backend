require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Vendors::Base do
  let(:object) { Object.new }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Vendors::NotImplementedError }
  let(:expected_attributes) do
    [:id, :business_name, :business_url, :charges_enabled, :country, :default_currency, :details_submitted,
     :display_name, :email, :managed, :statement_descriptor, :support_phone, :timezone, :transfers_enabled]
  end

  subject { base }

  it_behaves_like :a_base_object
end
