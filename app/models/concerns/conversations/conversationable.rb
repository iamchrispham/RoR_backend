module Conversations
  module Conversationable
    extend ActiveSupport::Concern

    included do
      has_many :conversation_participants, class_name: 'Conversations::ConversationParticipant', as: :participant
      has_many :conversations, -> { where(conversation_participants: { activated: true }) }, class_name: 'Conversations::Conversation', through: :conversation_participants, source: :conversation
      has_many :messages, class_name: 'Conversations::Message', through: :conversations, as: :owner
      has_many :messaged_objects, class_name: 'Conversations::MessagedObject', through: :messages, as: :recipient
    end

  end
end