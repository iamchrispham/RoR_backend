class CreateEventTimelineItemMediaItems < ActiveRecord::Migration
  def change
    create_table :event_timeline_item_media_items do |t|
      t.references :event_timeline_item, index: true, foreign_key: true, null: false
      t.attachment :video
      t.attachment :image
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end
  end
end
