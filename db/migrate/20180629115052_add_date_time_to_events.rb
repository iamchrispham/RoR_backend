class AddDateTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :date_time, :timestamp, index: true
  end
end
