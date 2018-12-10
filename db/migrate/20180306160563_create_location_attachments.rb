class CreateLocationAttachments < ActiveRecord::Migration
  def change
    create_table :location_attachments do |t|
      t.belongs_to :message_attachment, index: true, foreign_key: true
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.text :address

      t.timestamps null: false
    end
  end
end
