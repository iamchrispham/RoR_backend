class ShowoffSnsCreateNotifierGroupMembershipNotifiers < ActiveRecord::Migration
  def change
    create_table :group_membership_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_group_membership_notifiers_on_notification }, foreign_key: true, null: false
      t.references :membership, foreign_key: true, null: false

      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :group_membership_notifiers, [:owner_id, :owner_type], name: :index_group_membership_notifiers_on_owner
  end
end
