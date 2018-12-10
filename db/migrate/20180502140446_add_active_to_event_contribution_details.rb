class AddActiveToEventContributionDetails < ActiveRecord::Migration
  def change
    add_column :event_contribution_details, :active, :boolean, default: true, null: false
    add_index :event_contribution_details, :active
  end
end
