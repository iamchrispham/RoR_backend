class CreateShowoffSNSDevices < ActiveRecord::Migration
  def change
    create_table :showoff_sns_devices do |t|
      t.text :uuid, null: false, index: true
      t.string :platform, null: false, index: true
      t.boolean :active, default: true
      t.text :endpoint_arn, null: false
      t.text :push_token, null: false

      t.bigint :owner_id, index: true, null: false
      t.text :owner_type, index: true, null: false

      t.timestamps null: false
    end

    add_index :showoff_sns_devices, [:owner_id, :owner_type]
    add_index :showoff_sns_devices, [:uuid, :owner_id, :owner_type]
    add_index :showoff_sns_devices, [:active, :owner_id, :owner_type]
  end
end
