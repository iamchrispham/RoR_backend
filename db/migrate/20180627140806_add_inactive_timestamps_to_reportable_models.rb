class AddInactiveTimestampsToReportableModels < ActiveRecord::Migration
  def change
    add_column :event_timeline_items, :inactive_at, :timestamp, index: true
  end
end
