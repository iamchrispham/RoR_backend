class CreateMentionedAttributes < ActiveRecord::Migration
  def change
    create_table :mentioned_attributes do |t|
      t.string :attribute_name, null: false, index: true

      t.timestamps null: false
    end
  end
end
