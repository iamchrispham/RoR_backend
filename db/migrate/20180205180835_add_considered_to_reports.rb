class AddConsideredToReports < ActiveRecord::Migration
  def change
    add_column :reports, :considered, :boolean, null: false, default: false
    add_index :reports, :considered
  end
end
