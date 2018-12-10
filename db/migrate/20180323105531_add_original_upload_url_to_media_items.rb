class AddOriginalUploadUrlToMediaItems < ActiveRecord::Migration
  def change
    change_table :video_attachments do |t|
      t.text :uploaded_url, index: true
    end

    change_table :image_attachments do |t|
      t.text :uploaded_url, index: true
    end

    change_table :event_timeline_item_media_items do |t|
      t.text :uploaded_url, index: true
    end

    change_table :event_media_items do |t|
      t.text :uploaded_url, index: true
    end


  end
end
