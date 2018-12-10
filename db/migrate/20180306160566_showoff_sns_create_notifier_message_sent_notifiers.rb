class ShowoffSnsCreateNotifierMessageSentNotifiers < ActiveRecord::Migration
  def change
    create_table :message_sent_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_message_sent_notifiers_on_notification }, foreign_key: true, null: false
      t.belongs_to :conversation_message
  
      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :message_sent_notifiers, [:owner_id, :owner_type]
  end
end
