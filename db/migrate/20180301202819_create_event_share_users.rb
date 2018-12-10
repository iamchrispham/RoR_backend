class CreateEventShareUsers < ActiveRecord::Migration
  def change
    create_table :event_share_users do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :event_share, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
