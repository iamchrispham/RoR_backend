module Conversations
  module Messages
    class MessageSerializer < ApiSerializer
      attributes :id, :text, :owner, :attachments, :status, :created_at, :updated_at

      def owner
        serialized_resource(object.owner, ::Conversations::ConversationObjectsSerializer)
      end

      def attachments
        serialized_resource(object.message_attachments, ::Conversations::Messages::Attachments::AttachmentsSerializer)
      end
    end
  end
end
