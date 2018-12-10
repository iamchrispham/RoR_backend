class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.text :text, null: false

      t.timestamps null: false
    end

    add_index :tags, :text
  end
end
