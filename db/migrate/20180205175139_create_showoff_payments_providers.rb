class CreateShowoffPaymentsProviders < ActiveRecord::Migration
  def change
    create_table :showoff_payments_providers do |t|
      t.integer :name, null: false, default: 0, index: { name: :showoff_payment_providers_name }
      t.string :slug, null: false, index: { name: :showoff_payment_providers_slug }

      t.timestamps null: false
    end
  end
end
