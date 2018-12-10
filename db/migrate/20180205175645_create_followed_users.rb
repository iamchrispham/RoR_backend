class CreateFollowedUsers < ActiveRecord::Migration
  def change
    create_table :followed_users do |t|
      t.belongs_to :user, index: true
      t.references :followed_user, references: :users, index: true
      t.foreign_key :users, column: :followed_user_id

      t.timestamps null: false
    end
  end
end
