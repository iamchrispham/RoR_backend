require 'rails_helper'

RSpec.describe Showoff::Payments::Providers::Sources::Base do
  let(:object) { Object.new }
  let(:base) { described_class.new(object) }
  let(:error_class) { Showoff::Payments::Providers::Sources::NotImplementedError }
  let(:expected_attributes) do
    [:id, :address_city, :address_country, :address_line1, :address_line2, :address_line1_check,
     :address_state, :address_zip, :address_zip_check, :brand, :country, :customer,
     :cvc_check, :exp_month, :exp_year, :fingerprint, :funding, :last4, :name]
  end

  subject { base }

  it_behaves_like :a_base_object
end
