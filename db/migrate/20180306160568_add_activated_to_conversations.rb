class AddActivatedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :activated, :boolean, default: true
  end
end
