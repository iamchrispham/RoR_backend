class CreateMessagedObjects < ActiveRecord::Migration
  def change
    create_table :messaged_objects do |t|
      t.string :recipient_type, index: true
      t.integer :recipient_id, index: true
      t.belongs_to :message, index: true, foreign_key: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
