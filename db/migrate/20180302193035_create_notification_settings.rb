class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end
  end
end
