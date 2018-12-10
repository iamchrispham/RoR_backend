class AddEventToConversations < ActiveRecord::Migration
  def change
    add_reference :conversations, :event, index: true, foreign_key: true
  end
end
