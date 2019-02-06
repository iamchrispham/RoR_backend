# frozen_string_literal: true

class CreateSubgroupEventsApprovals < ActiveRecord::Migration
  def change
    create_table :subgroup_events_approvals do |t|
      t.boolean :active, null: false, default: false

      t.references :group, null: false
      t.references :subgroup, null: false
      t.references :user, null: false
      t.references :event, null: false

      t.index %i[group_id subgroup_id event_id], unique: true, name: :index_group_subgroup_event_uniq
      t.index %i[user_id group_id subgroup_id event_id], name: :index_group_subgroup_event_user

      t.timestamps null: false
    end
  end
end
