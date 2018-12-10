class AddDisplayAddressToEvent < ActiveRecord::Migration
  def change
    add_column :events, :display_address, :text
  end
end
