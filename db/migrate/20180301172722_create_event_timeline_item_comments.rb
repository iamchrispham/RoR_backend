class CreateEventTimelineItemComments < ActiveRecord::Migration
  def change
    create_table :event_timeline_item_comments do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :event_timeline_item, index: true, foreign_key: true, null: false
      t.text :content, null: false
      t.timestamp :inactive_at
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end

    add_column :event_timeline_items, :number_of_comments, :integer, default: 0, null: false
  end
end
