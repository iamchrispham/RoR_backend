class CreateSNSNotifiedObjects < ActiveRecord::Migration
  def change
    create_table :showoff_sns_notified_objects do |t|
      t.integer :status, null: false, default: 0, index: { name: :sns_notified_object_status }
      t.belongs_to :showoff_sns_notification, index: { name: :sns_notified_object_notification }
      t.belongs_to :showoff_sns_notified_class, index: { name: :sns_notified_object_notified_class }

      t.bigint :notifiable_id, index: true
      t.string :notifiable_type, index: true

      t.timestamps null: false
    end

    add_index :showoff_sns_notified_objects, [:notifiable_id, :notifiable_type], name: :sns_notified_object_notifiable
  end
end
