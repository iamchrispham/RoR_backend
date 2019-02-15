class AddStatusToGroupInvitations < ActiveRecord::Migration
  def change
    add_column :group_invitations, :status, :integer, default: 0
  end
end
