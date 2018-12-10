class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :owner_type, null: false
      t.integer :owner_id, null: false
      t.text :text, null: false
      t.integer :status, index: true, null: false
      t.belongs_to :conversation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
