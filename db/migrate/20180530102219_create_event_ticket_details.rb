class CreateEventTicketDetails < ActiveRecord::Migration
  def change
    create_table :event_ticket_details do |t|
      t.references :event, index: true, foreign_key: true
      t.text :url, null: false
      t.boolean :active, null: false, default: true, index: true

      t.timestamps null: false
    end
  end
end
