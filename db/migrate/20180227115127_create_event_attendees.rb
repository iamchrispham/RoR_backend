class CreateEventAttendees < ActiveRecord::Migration
  def change
    create_table :event_attendees do |t|
      t.references :event, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :status, index: true, null: false, default: 0
      t.boolean :invited, index: true, null: false, default: false

      t.timestamps null: false
    end
  end
end
