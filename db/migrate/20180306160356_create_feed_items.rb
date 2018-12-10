class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.references :feed_item_context, index: true, foreign_key: true, null: false
      t.references :object, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
