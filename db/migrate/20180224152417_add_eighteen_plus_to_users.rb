class AddEighteenPlusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :eighteen_plus, :boolean, default: false
    add_index :users, :eighteen_plus
  end
end
