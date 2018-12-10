class ChangeUserColumns < ActiveRecord::Migration
  def change
    remove_column :users, :following_count
    remove_column :users, :followers_count

    add_column :users, :friend_count, :integer, default: 0, null: false, index: true
  end
end
