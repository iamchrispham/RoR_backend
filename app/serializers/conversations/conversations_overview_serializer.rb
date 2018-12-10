module Conversations
  class ConversationsOverviewSerializer < ApiSerializer
    attributes :id, :unread, :unread_count, :participant_count, :created_at, :updated_at, :meta_data, :participants, :messages, :owner

    def participant_count
      object.participants.activated.count
    end

    def unread
      return false if instance_user.blank?
      object.unread(instance_user)
    end

    def unread_count
      return 0 if instance_user.blank?
      object.unread_count(instance_user)
    end

    def participants
      serialized_resource(object.participants.activated.map(&:participant), ::Conversations::ConversationObjectsSerializer, conversation: object, user: instance_user)
    end

    def messages
      serialized_resource(object.latest_message, ::Conversations::Messages::MessageSerializer)
    end

    def meta_data
      serialized_resource(object, ::Conversations::ConversationDataSerializer)
    end

    def owner
      object&.owner&.eql?(instance_user)
    end

    private

    def instance_user
      instance_options[:user]
    end
  end
end
