class CreateUserFeedItems < ActiveRecord::Migration
  def change
    create_table :user_feed_items do |t|
      t.references :feed_item, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
