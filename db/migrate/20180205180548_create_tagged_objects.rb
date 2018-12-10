class CreateTaggedObjects < ActiveRecord::Migration
  def change
    create_table :tagged_objects do |t|
      t.belongs_to :tag

      t.integer :taggable_id, null: false
      t.string :taggable_type, null: false

      t.integer :owner_id, null: false
      t.string :owner_type, null: false

      t.integer :start_index, null: false
      t.integer :end_index, null: false

      t.timestamps null: false
    end

    add_index :tagged_objects, [:taggable_id, :taggable_type]
    add_index :tagged_objects, [:owner_id, :owner_type]
  end
end
