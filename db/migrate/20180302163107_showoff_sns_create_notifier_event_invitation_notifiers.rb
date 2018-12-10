class ShowoffSnsCreateNotifierEventInvitationNotifiers < ActiveRecord::Migration
  def change
    create_table :event_invitation_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_event_invitation_notifiers_on_notification }, foreign_key: true, null: false
      t.references :event_attendee, foreign_key: true, null: false, index: true
  
      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :event_invitation_notifiers, [:owner_id, :owner_type]
  end
end
