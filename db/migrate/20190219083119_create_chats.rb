class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.references :chatable, polymorphic: true, index: true
      t.string :chatkit_id

      t.timestamps null: false
    end
  end
end
