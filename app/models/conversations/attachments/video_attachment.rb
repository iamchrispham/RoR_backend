module Conversations
  module Attachments
    class VideoAttachment < ActiveRecord::Base
      include Showoff::Concerns::Videoable
      include Conversations::Attachments::Attachable

      def default_serializer
        '::Conversations::Messages::Attachments::VideoAttachmentSerializer'
      end

      def attachment_type
        :video
      end

      def videos
        if video?
          { original_url: video.url(:original) }
        elsif uploaded_url.present?
          { original_url: uploaded_url }
        end
      end
    end
  end
end
