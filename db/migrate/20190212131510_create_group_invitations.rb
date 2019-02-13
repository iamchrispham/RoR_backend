# frozen_string_literal: true

class CreateGroupInvitations < ActiveRecord::Migration
  def change
    create_table :group_invitations do |t|
      t.references :group, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :active, null: false, default: false
      t.index %i[group_id user_id], unique: true
      t.timestamps null: false
    end
  end
end
