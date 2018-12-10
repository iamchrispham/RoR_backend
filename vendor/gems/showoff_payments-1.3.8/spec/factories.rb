FactoryGirl.define do
  sequence(:provider_identifier) { |i| "provider_identifier#{i}" }
  sequence(:provider_key) { |i| "provider_key#{i}" }
  sequence(:provider_secret) { |i| "provider_secret#{i}" }
  sequence(:last_four) { |i| "last_four_#{i}" }
  sequence(:exp_month) { |i| i }
  sequence(:exp_year) { |i| i }
  sequence(:brand) { |i| "Visa_#{i}" }
  sequence(:country) { |i| "country_#{i}" }

  sequence(:name) { |_i| :stripe }
  sequence(:slug) { |_i| 'stripe' }
  sequence(:email) { |i| "test#{i}@test.com" }
  sequence(:amount, &:to_f)
  sequence(:application_fee, &:to_f)
  sequence(:currency) { |_i| 'EUR' }

  factory :purchase do
  end

  factory :vendor do
    email
  end

  factory :customer do
    email
  end

  factory :provider, class: Showoff::Payments::Provider do
    name
    slug
  end

  factory :customer_identity, class: Showoff::Payments::Customers::Identity do
    customer
    vendor_identity
    provider_identifier

    after(:build) do |id|
      id.provider = (Showoff::Payments::Provider.first || FactoryGirl.create(:provider))
    end
  end

  factory :vendor_identity, class: Showoff::Payments::Vendors::Identity do
    vendor
    provider_identifier

    if ::Showoff::Payments.configuration.managed_accounts_enabled
      provider_key
      provider_secret
    end

    after(:build) do |id|
      id.provider = (Showoff::Payments::Provider.first || FactoryGirl.create(:provider))
    end

    factory :managed_vendor_identity do
      provider_key
      provider_secret
    end

  end

  factory :receipt, class: Showoff::Payments::Receipt do
    purchase
    customer_identity
    vendor_identity
    provider_identifier
    amount
    application_fee
    currency
  end

  factory :refund, class: Showoff::Payments::Refund do
    receipt
    provider_identifier
    amount
  end

  factory :source, class: Showoff::Payments::Source do
    customer_identity
    vendor_identity
    provider_identifier
    last_four
    country
    brand
    exp_month
    exp_year
  end
end
