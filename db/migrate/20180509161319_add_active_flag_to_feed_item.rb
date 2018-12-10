class AddActiveFlagToFeedItem < ActiveRecord::Migration
  def change
    add_column :feed_items, :active, :boolean, null: false, default: true, index: true
  end
end
