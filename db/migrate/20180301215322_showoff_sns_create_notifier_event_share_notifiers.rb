class ShowoffSnsCreateNotifierEventShareNotifiers < ActiveRecord::Migration
  def change
    create_table :event_share_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_event_share_notifiers_on_notification }, foreign_key: true, null: false
      t.references :event_share, foreign_key: true, index: true, null: false
  
      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :event_share_notifiers, [:owner_id, :owner_type]
  end
end
