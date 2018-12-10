class CreateShowoffFacebookFriendNotifiers < ActiveRecord::Migration
  def change
    create_table :showoff_facebook_friend_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_facebook_friend_notifier_on_notification }, foreign_key: true

      t.bigint :owner_id, index: true, null: false
      t.text :owner_type, index: true, null: false

      t.text :facebook_username, null: false

      t.timestamps null: false
    end

    add_index :showoff_facebook_friend_notifiers, [:owner_type, :owner_id], name: :index_showoff_facebook_friend_notifiers_on_owner
  end
end
