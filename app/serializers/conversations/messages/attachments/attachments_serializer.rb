module Conversations
  module Messages
    module Attachments
      class AttachmentsSerializer < ApiSerializer
        attributes :id, :type, :attachment, :created_at, :updated_at

        def attachment
          serialized_resource(object.attachment, object.attachment.default_serializer.constantize)
        end

        def type
          object.attachment.attachment_type
        end
      end
    end
  end
end
