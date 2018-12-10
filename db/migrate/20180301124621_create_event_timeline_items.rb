class CreateEventTimelineItems < ActiveRecord::Migration
  def change
    create_table :event_timeline_items do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :event, index: true, foreign_key: true, null: false
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end
  end
end
