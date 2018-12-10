class AddOwnerToGroupConversation < ActiveRecord::Migration
  def change
    add_belongs_to :conversations, :owner, polymorphic: true, index: true
  end
end
