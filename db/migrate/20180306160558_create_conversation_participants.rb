class CreateConversationParticipants < ActiveRecord::Migration
  def change
    create_table :conversation_participants do |t|
      t.string :participant_type
      t.integer :participant_id
      t.boolean :muted, default: false
      t.boolean :activated, default: true
      t.belongs_to :conversation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
