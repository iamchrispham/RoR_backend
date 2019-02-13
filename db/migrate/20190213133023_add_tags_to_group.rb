class AddTagsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_tags, :text
  end
end
