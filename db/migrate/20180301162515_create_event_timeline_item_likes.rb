class CreateEventTimelineItemLikes < ActiveRecord::Migration
  def change
    create_table :event_timeline_item_likes do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :event_timeline_item, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_column :event_timeline_items, :number_of_likes, :integer, default: 0, null: false
  end
end
