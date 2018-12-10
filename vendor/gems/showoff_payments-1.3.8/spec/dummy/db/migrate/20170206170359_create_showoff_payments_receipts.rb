class CreateShowoffPaymentsReceipts < ActiveRecord::Migration
  def change
    create_table :showoff_payments_receipts do |t|
      t.integer :status, null: false, default: 0, index: true

      t.belongs_to :customer_identity, null: false, index: true
      t.bigint :purchase_id, null: false
      t.string :purchase_type, null: false, index: true

      t.float :amount, null: false
      t.float :application_fee, null: false

      t.integer :credits, null: false, default: 0, index: true

      t.string :currency, null: false, index: true

      t.integer :quantity, null: false, index: true, default: 1
      t.text :notes

      t.integer :address_id, index: true
      t.string :address_type, index: true

      t.text :provider_identifier, null: false, index: true

      t.timestamps null: false
    end

    add_index :showoff_payments_receipts, [:purchase_id, :purchase_type], name: :showoff_payments_receipts_purchase
    add_index :showoff_payments_receipts, [:address_id, :address_type], name: :showoff_payments_receipts_address
  end
end
