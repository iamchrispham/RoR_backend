class AddFacebookIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :facebook_id, :text
    add_index :events, :facebook_id
  end
end
