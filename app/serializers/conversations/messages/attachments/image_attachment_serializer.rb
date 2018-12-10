module Conversations
  module Messages
    module Attachments
      class ImageAttachmentSerializer < ApiSerializer
        attributes :id, :images, :created_at, :updated_at, :type

        def type
          object.attachment_type
        end

        def images
          object.formatted_images
        end
      end
    end
  end
end
