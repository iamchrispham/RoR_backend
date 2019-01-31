# frozen_string_literal: true

class AddUniqIndexToMemberships < ActiveRecord::Migration
  def change
    remove_index :memberships, column: %i[user_id group_id]
    add_index :memberships, %i[user_id group_id], unique: true
  end
end
