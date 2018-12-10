class AddAcceptanceRequiredToEvents < ActiveRecord::Migration
  def change
    add_column :events, :attendance_acceptance_required, :boolean, default: false
    add_index :events, :attendance_acceptance_required
  end
end
