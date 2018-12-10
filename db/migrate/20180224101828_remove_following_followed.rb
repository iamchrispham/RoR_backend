class RemoveFollowingFollowed < ActiveRecord::Migration
  def change
    drop_table :user_followed_notifiers
    drop_table :followed_users
  end
end
