class CreateEventTicketDetailViews < ActiveRecord::Migration
  def change
    create_table :event_ticket_detail_views do |t|
      t.references :event_ticket_detail, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.boolean :active, null: false, default: true, index: true

      t.timestamps null: false
    end
  end
end
