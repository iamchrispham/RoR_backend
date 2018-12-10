class AddMediaTypeToMediaItems < ActiveRecord::Migration
  def change
    change_table :event_timeline_item_media_items do |t|
      t.string :media_type, index: true
    end

    change_table :event_media_items do |t|
      t.string :media_type, index: true
    end

    EventMediaItem.all.each do |media|
      media.update_attributes(media_type: media.video? ? 'video' : 'image')
    end

    EventTimelineItemMediaItem.all.each do |media|
      media.update_attributes(media_type: media.video? ? 'video' : 'image')
    end
  end
end
