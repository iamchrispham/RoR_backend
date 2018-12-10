class CreateSnsNotifications < ActiveRecord::Migration
  def change
    create_table :showoff_sns_notifications do |t|
      t.integer :status, null: false, default: 0
      t.integer :subscriber_count
      t.datetime :sent_at

      t.bigint :notifier_id, index: true
      t.string :notifier_type, index: true

      t.timestamps null: false
    end

    add_index :showoff_sns_notifications, [:notifier_id, :notifier_type], name: :sns_notifications_notifier
  end
end
