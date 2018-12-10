class ShowoffSnsCreateNotifierEventAttendeeRequestResponseNotifiers < ActiveRecord::Migration
  def change
    create_table :event_attendee_request_response_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_event_attendee_request_response_notifiers_on_notification }, foreign_key: true, null: false
      t.references :event_attendee_request, foreign_key: true, null: false
  
      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :event_attendee_request_response_notifiers, [:owner_id, :owner_type], name: :index_event_attendee_request_response_notifiers_on_owner
  end
end
