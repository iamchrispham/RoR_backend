module Conversations
  module Messages
    module Attachments
      class LocationAttachmentSerializer < ApiSerializer
        attributes :id, :coordinates, :address, :created_at, :updated_at, :type

        def type
          object.attachment_type
        end
      end
    end
  end
end
