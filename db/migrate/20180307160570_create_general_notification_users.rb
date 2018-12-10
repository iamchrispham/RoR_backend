class CreateGeneralNotificationUsers < ActiveRecord::Migration
  def change
    create_table :general_notification_users do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :general_notification, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
