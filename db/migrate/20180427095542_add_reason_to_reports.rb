class AddReasonToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reason, :integer, null: false, default: 0
    add_index :reports, :reason
  end
end
