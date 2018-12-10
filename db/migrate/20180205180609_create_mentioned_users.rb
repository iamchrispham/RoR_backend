class CreateMentionedUsers < ActiveRecord::Migration
  def change
    create_table :mentioned_users do |t|
      t.references :mentioned_user, references: :users, index: true
      t.foreign_key :users, column: :mentioned_user_id

      t.integer :owner_id, null: false
      t.string :owner_type, null: false

      t.integer :mentionable_id, null: false
      t.string :mentionable_type, null: false

      t.integer :start_index, null: false
      t.integer :end_index, null: false

      t.timestamps null: false
    end

    add_index :mentioned_users, [:owner_id, :owner_type]
    add_index :mentioned_users, [:mentionable_id, :mentionable_type]
  end
end
