module Conversations
  class ConversationParticipant < ActiveRecord::Base
    belongs_to :conversation, class_name: 'Conversations::Conversation'
    belongs_to :participant, polymorphic: true

    scope :activated, -> { where(activated: true) }
  end
end
