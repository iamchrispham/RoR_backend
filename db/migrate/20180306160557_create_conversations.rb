class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      t.string :purpose
      t.attachment :image
      t.timestamps null: false
    end
  end
end
