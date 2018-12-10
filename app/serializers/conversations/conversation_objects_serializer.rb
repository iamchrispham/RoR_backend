module Conversations
  class ConversationObjectsSerializer < ApiSerializer
    attributes :id, :type, :muted, :instance

    def id
      object.id
    end

    def instance
      object.cached(instance_options[:user], type: :feed)
    end

    def type
      object.class.to_s
    end

    def muted
      return false unless instance_options[:conversation]
      instance_options[:conversation].muted(object)
    end
  end
end
