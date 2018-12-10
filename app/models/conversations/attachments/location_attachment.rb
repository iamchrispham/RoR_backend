module Conversations
  module Attachments
    class LocationAttachment < ActiveRecord::Base
      include Showoff::Concerns::Geocodable
      include Conversations::Attachments::Attachable

      def default_serializer
        return '::Conversations::Messages::Attachments::LocationAttachmentSerializer'
      end

      def attachment_type
        :location
      end

    end
  end
end
