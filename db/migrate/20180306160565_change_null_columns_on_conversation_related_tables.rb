class ChangeNullColumnsOnConversationRelatedTables < ActiveRecord::Migration
  def change
    change_column_null :conversation_participants, :conversation_id, false
    change_column_null :messages, :conversation_id, false
    change_column_null :messaged_objects, :message_id, false
    change_column_null :message_attachments, :message_id, false
  end
end
