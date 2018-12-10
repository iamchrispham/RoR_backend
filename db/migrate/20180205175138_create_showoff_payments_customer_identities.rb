class CreateShowoffPaymentsCustomerIdentities < ActiveRecord::Migration
  def change
    create_table :showoff_payments_customer_identities do |t|
      t.bigint :customer_id, null: false
      t.string :customer_type, null: false, index: { name: :showoff_payments_customer_identities_customer_type }

      t.belongs_to :vendor_identity, null: true, index: { name: :showoff_payments_customer_identities_vendor_identity }
      t.belongs_to :provider, null: false, index: { name: :showoff_payments_customer_identities_payment_provider }

      t.boolean :active, null: false, default: true, index: { name: :showoff_payments_customer_identities_active }
      t.text :provider_identifier, null: false, index: { name: :showoff_payments_customer_identities_provider_identifier }

      t.timestamps null: false
    end

    add_index :showoff_payments_customer_identities, [:customer_id, :customer_type], name: :showoff_payments_customer_identities_customer
  end
end
