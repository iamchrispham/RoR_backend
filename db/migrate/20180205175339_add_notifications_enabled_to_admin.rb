class AddNotificationsEnabledToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :notifications_enabled, :boolean, default: true, index: true, null: false
  end
end
