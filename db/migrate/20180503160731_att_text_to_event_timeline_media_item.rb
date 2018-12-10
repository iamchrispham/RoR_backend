class AttTextToEventTimelineMediaItem < ActiveRecord::Migration
  def change
    add_column :event_timeline_item_media_items, :text, :string
  end
end
