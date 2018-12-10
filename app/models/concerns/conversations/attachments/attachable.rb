module Conversations
  module Attachments
    module Attachable
      extend ActiveSupport::Concern

      included do
        belongs_to :message_attachment, class_name: 'Conversations::MessageAttachment'
      end

      def default_serializer
        raise NotImplementedError
      end

      def attachment_type
        raise NotImplementedError
      end
    end
  end
end