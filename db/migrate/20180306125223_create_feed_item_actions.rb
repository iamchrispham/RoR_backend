class CreateFeedItemActions < ActiveRecord::Migration
  def change
    create_table :feed_item_actions do |t|
      t.string :slug, null: false
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        FeedItemAction.create_translation_table! action: :string
      end

      dir.down do
        FeedItemAction.drop_translation_table!
      end
    end
  end
end
