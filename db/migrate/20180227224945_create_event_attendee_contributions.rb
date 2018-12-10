class CreateEventAttendeeContributions < ActiveRecord::Migration
  def change
    create_table :event_attendee_contributions do |t|
      t.references :event_attendee, index: true, foreign_key: true, null: false
      t.monetize :amount, currency: { present: false }, index: true
      t.boolean :active, null: false, index: true, default: true
      t.integer :status, default: 0, index: true, null: false

      t.timestamps null: false
    end
  end
end
