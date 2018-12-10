class AddMaximumNumberOfAttendeesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :maximum_attendees, :integer
    add_index :events, :maximum_attendees
  end
end
