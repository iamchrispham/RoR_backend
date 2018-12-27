class AddPriceToEvent < ActiveRecord::Migration
  def change
    add_column :events, :price, :integer

    add_index :events, :price
  end
end
