class CreateUserNotificationSettings < ActiveRecord::Migration
  def change
    create_table :user_notification_settings do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
