class CreateFeedItemContexts < ActiveRecord::Migration
  def change
    create_table :feed_item_contexts do |t|
      t.references :feed_item_action, index: true, foreign_key: true, null: false
      t.references :actor, polymorphic: true, index: true, null: false
      t.references :object, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
