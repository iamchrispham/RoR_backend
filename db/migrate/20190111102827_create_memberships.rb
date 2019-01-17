# frozen_string_literal: true

class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :group
      t.references :user

      t.index %i[group_id user_id]
      t.index %i[user_id group_id]

      t.timestamps null: false
    end

    add_foreign_key 'memberships', 'groups',
                    name: 'memberships_group_id_fk',
                    on_delete: :cascade

    add_foreign_key 'memberships', 'users',
                    name: 'memberships_user_id_fk',
                    on_delete: :cascade
  end
end
