module Conversations
  class MessageSentNotifier < Showoff::SNS::Notifier::Base

    belongs_to :conversation_message, foreign_key: :conversation_message_id, class_name: 'Conversations::Message'
    validates :conversation_message, presence: true

    after_commit :send_notification, on: :create

    def set_owner
      self.owner = conversation_message.owner
    end

    def self.notification_type
      :message_sent
    end

    def subscribers
      conversation_message.recipients
    end

    def message(target)
      conversation_message.notification_text(target)
    end

    def extra_information(_target)
      {
        message_id: conversation_message.id,
        conversation_id: conversation_message.conversation.id,
        event_id: conversation_message.conversation.event.present? ? conversation_message.conversation.event.id : nil
      }
    end

    def should_notify?(target)
      slug = conversation_message.conversation.event.present? ? 'event_chat' : 'other_chat'
      target.notifications_enabled_for(slug) && !conversation_message.conversation.muted(target)
    end

    def resources(_target)
      {
        message: serialized_resource(conversation_message, ::Conversations::Messages::MessageSerializer),
        conversation_id: conversation_message.conversation.id,
        event_id: conversation_message.conversation.event.present? ? conversation_message.conversation.event.id : nil
      }
    end
  end
end
