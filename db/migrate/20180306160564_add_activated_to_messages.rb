class AddActivatedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :activated, :boolean, default: true, null: false
  end
end
