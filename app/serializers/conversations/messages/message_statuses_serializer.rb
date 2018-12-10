module Conversations
  module Messages
    class MessageStatusesSerializer < ApiSerializer
      attributes :id, :recipient, :status, :created_at, :updated_at

      def recipient
        serialized_resource(object.recipient, ::Conversations::ConversationObjectsSerializer, conversation: object.message.conversation)
      end
    end
  end
end
