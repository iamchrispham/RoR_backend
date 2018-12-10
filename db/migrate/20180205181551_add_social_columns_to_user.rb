class AddSocialColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :following_count, :integer, default: 0, null: false, index: true
    add_column :users, :followers_count, :integer, default: 0, null: false, index: true

    add_column :users, :suspended, :boolean, null: false, default: false
    add_index :users, :suspended

    add_index :users, [:suspended, :active]

    add_column :users, :inactive_at, :datetime, null: true
    add_column :users, :suspended_at, :datetime, null: true

    add_index :users, :inactive_at
    add_index :users, :suspended_at
  end
end
