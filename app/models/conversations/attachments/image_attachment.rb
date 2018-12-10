module Conversations
  module Attachments
    class ImageAttachment < ActiveRecord::Base
      include Showoff::Concerns::Imagable
      include Conversations::Attachments::Attachable

      def default_serializer
        return '::Conversations::Messages::Attachments::ImageAttachmentSerializer'
      end

      def attachment_type
        :image
      end

      def formatted_images
        return images if image?
        uploaded_images
      end

      def uploaded_images
        {
            small_url: uploaded_url,
            medium_url: uploaded_url,
            large_url: uploaded_url,
            original_url: uploaded_url
        }
      end
    end
  end
end
