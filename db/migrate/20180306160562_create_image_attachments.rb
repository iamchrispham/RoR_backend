class CreateImageAttachments < ActiveRecord::Migration
  def change
    create_table :image_attachments do |t|
      t.belongs_to :message_attachment, index: true, foreign_key: true
      t.attachment :image

      t.timestamps null: false
    end
  end
end
