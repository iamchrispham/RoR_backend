class ShowoffSnsCreateNotifierUserFollowedNotifiers < ActiveRecord::Migration
  def change
    create_table :user_followed_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_user_followed_notifiers_on_notification }, foreign_key: true, null: false
      t.belongs_to :followed_user, index: true, foreign_key: true, null: false

      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :user_followed_notifiers, [:owner_id, :owner_type], name: :index_user_followed_notifiers_on_owner
  end
end
