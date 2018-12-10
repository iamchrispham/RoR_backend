class CreateVideoAttachments < ActiveRecord::Migration
  def change
    create_table :video_attachments do |t|
      t.belongs_to :message_attachment, index: true, foreign_key: true
      t.attachment :video

      t.timestamps null: false
    end
  end
end
