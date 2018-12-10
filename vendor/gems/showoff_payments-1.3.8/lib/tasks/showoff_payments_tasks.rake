namespace :showoff do
  namespace :payments do
    desc 'Load Payment Providers'
    task create_providers: :environment do
      providers = [
        { name: :stripe, slug: 'stripe' }
      ]

      providers.each do |provider|
        Showoff::Payments::Provider.find_or_create_by(provider)
      end
    end

    desc 'Update Missing Customer Identity Providers'
    task update_missing_customer_identities_providers_with_vendor_identity_providers: :environment do

      Showoff::Payments::Customers::Identity.all.each do |customer_identity|
        if customer_identity.provider.blank? && customer_identity.vendor_identity.present?
          customer_identity.update_attributes(provider: customer_identity.vendor_identity.provider)
        end
      end

    end

    desc 'Update Missing Vendor Identities on Receipts'
    task update_missing_vendor_identities_on_receipts: :environment do

      Showoff::Payments::Receipt.all.each do |receipt|
        if receipt.vendor_identity.blank? && receipt.customer_identity.present? && receipt.customer_identity.vendor_identity.present?
          receipt.update_attributes(vendor_identity: receipt.customer_identity.vendor_identity)
        end
      end

    end
  end
end
