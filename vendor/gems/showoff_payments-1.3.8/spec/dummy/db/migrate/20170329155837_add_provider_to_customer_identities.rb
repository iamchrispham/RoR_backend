class AddProviderToCustomerIdentities < ActiveRecord::Migration
  def change
    change_column_null :showoff_payments_customer_identities, :vendor_identity_id, true
    add_column :showoff_payments_customer_identities, :provider_id, :integer, index: { name: :showoff_payments_customer_identities_payment_provider }
  end
end
