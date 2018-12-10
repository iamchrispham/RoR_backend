class CreateTaggedAttributes < ActiveRecord::Migration
  def change
    create_table :tagged_attributes do |t|
      t.string :attribute_name, null: false, index: true

      t.timestamps null: false
    end
  end
end
