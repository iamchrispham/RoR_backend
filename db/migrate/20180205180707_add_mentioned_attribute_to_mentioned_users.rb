class AddMentionedAttributeToMentionedUsers < ActiveRecord::Migration
  def change
    add_belongs_to :mentioned_users, :mentioned_attribute, null: false, index: true
  end
end
