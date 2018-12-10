class ShowoffSnsCreateNotifierEventTimelineItemCommentNotifiers < ActiveRecord::Migration
  def change
    create_table :event_timeline_item_comment_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_event_timeline_item_comment_notifiers_on_notification }, foreign_key: true, null: false
      t.references :event_timeline_item_comment, foreign_key: true, null: false, index: {name: :index_event_timeline_item_on_event_timeline_item_comment}
  
      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :event_timeline_item_comment_notifiers, [:owner_id, :owner_type], name: :index_event_timeline_item_comment_notifiers_on_owner
  end
end
