module Conversations
  module Messages
    module Attachments
      class VideoAttachmentSerializer < ApiSerializer
        attributes :id, :videos, :images, :created_at, :updated_at, :type

        def images
          object.video_images
        end

        def type
          object.attachment_type
        end
      end
    end
  end
end
