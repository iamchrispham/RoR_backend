class CreateShowoffPaymentsVendorIdentities < ActiveRecord::Migration
  def change
    create_table :showoff_payments_vendor_identities do |t|
      t.bigint :vendor_id, null: false
      t.string :vendor_type, null: false, index: { name: :showoff_payments_vendor_identities_vendor_type }
      t.belongs_to :provider, null: false, index: { name: :showoff_payments_vendor_identities_payment_provider }

      t.boolean :active, null: false, default: true, index: { name: :showoff_payments_vendor_identities_active }
      t.text :provider_identifier, null: false, index: { name: :showoff_payments_vendor_identities_provider_identifier }

      t.timestamps null: false
    end

    add_index :showoff_payments_vendor_identities, [:vendor_id, :vendor_type], name: :showoff_payments_vendor_identities_vendor
  end
end
