class AddForeignKeysToSNSNotifiedObjects < ActiveRecord::Migration
  def change
    add_foreign_key :showoff_sns_notified_objects, :showoff_sns_notifications
  end
end
