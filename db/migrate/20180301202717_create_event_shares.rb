class CreateEventShares < ActiveRecord::Migration
  def change
    create_table :event_shares do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :event, index: true, foreign_key: true, null: false
      t.boolean :active, null: false, default: true, index: true

      t.timestamps null: false
    end
  end
end
