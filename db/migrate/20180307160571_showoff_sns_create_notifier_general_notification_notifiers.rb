class ShowoffSnsCreateNotifierGeneralNotificationNotifiers < ActiveRecord::Migration
  def change
    create_table :general_notification_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_general_notification_notifiers_on_notification }, foreign_key: true, null: false
      t.references :general_notification, foreign_key: true, null: false, index: true

      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :general_notification_notifiers, [:owner_id, :owner_type], name: :index_general_notification_notifiers_on_owner
  end
end
