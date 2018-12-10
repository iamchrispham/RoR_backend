module Conversations
  class ConversationDataSerializer < ApiSerializer
    attributes :name, :purpose, :images
  end
end
