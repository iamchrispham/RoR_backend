class CreateEventAttendeeRequests < ActiveRecord::Migration
  def change
    create_table :event_attendee_requests do |t|
      t.belongs_to :event_attendee, index: true, foreign_key: true, null: false
      t.integer :status, default: 0, index: true, null: false

      t.timestamps null: false
    end
  end
end
