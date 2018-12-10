class ShowoffSnsCreateNotifierUpcomingEventNotifiers < ActiveRecord::Migration
  def change
    create_table :upcoming_event_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_upcoming_event_notifiers_on_notification }, foreign_key: true, null: false
      t.belongs_to :event, null: false, index: true

      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :upcoming_event_notifiers, [:owner_id, :owner_type]
  end
end
