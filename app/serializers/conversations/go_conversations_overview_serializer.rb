module Conversations
  class GoConversationsOverviewSerializer < ConversationsOverviewSerializer
    attributes :event, :muted, :owner

    def participants
      return [] if instance_options[:exclude_participants]
      serialized_resource(object.participants.activated.map(&:participant), ::Conversations::ConversationObjectsSerializer, conversation: object, user: instance_user)
    end

    def participant_count
      if object.event.present?
        object.event.attending_users.count
      else
        object.participants.activated.count
      end
    end

    def muted
      return false unless instance_user
      object.muted(instance_user)
    end

    def owner
      return false unless instance_user
      return object.owner.eql?(instance_user)
    end

    def messages
      messages = object.latest_message
      return [] if messages.size.zero?

      message = messages.first
      return [] if message.blank?

      [{
        id: message.id,
        text: message.formatted_text(instance_user),
        owner: serialized_resource(message.owner, ::Conversations::ConversationObjectsSerializer, user: instance_user),
        created_at: message.created_at,
        updated_at: message.updated_at
      }]
    end

    def event
      serialized_resource(object.event, ::Conversations::Events::Feed::OverviewSerializer, user: instance_user)
    end
  end
end
