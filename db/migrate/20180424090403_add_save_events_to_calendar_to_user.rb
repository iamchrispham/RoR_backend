class AddSaveEventsToCalendarToUser < ActiveRecord::Migration
  def change
    add_column :users, :save_events_to_calendar, :boolean, index: true, default: false, null: false
  end
end
