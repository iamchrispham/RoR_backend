module Conversations
  class ConversationObjectSerializer < ApiSerializer
    attributes :id, :first_name, :last_name, :email, :images, :created_at, :updated_at
  end
end
