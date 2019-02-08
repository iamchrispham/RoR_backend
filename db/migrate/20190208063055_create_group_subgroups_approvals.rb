# frozen_string_literal: true

class CreateGroupSubgroupsApprovals < ActiveRecord::Migration
  def change
    create_table :group_subgroup_approvals do |t|
      t.boolean :active, null: false, default: false

      t.references :group, null: false
      t.references :subgroup, null: false
      t.references :user, null: false

      t.index %i[group_id subgroup_id], unique: true, name: :index_group_subgroup_uniq
      t.index %i[user_id group_id subgroup_id], name: :index_group_subgroup_user

      t.timestamps null: false
    end
  end
end
