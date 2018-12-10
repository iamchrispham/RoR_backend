class CreateEventMediaItems < ActiveRecord::Migration
  def change
    create_table :event_media_items do |t|
      t.references :event, index: true, foreign_key: true, null: false
      t.attachment :video
      t.attachment :image
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end
  end
end
