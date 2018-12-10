class CreateMessageAttachments < ActiveRecord::Migration
  def change
    create_table :message_attachments do |t|
      t.string :attachment_type, null: false
      t.integer :attachment_id, null: false
      t.belongs_to :message, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
