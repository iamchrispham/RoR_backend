class CreateGeneralNotifications < ActiveRecord::Migration
  def change
    create_table :general_notifications do |t|
      t.string :title, null: false
      t.text :message, null: false
      t.references :owner, polymorphic: true, index: true, null: false
      t.references :platform, index: true, foreign_key: true, null: false
      t.string :target_mode, null: false, default: 'user'
      t.integer :status, index: true, null: false, default: 0

      t.timestamps null: false
    end
  end
end
