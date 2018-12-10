class CreateNotificationSettingUserNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_setting_user_notification_settings do |t|
      t.references :user_notification_setting, index: {name: :index_notification_setting_on_user_setting_id}, foreign_key: true, null: false
      t.references :notification_setting, index: {name: :index_notification_setting_on_notification_setting_id}, foreign_key: true, null: false
      t.boolean :enabled, default: true, null: false, index: { name: :index_notification_settings_on_enabled}

      t.timestamps null: false
    end
  end
end
