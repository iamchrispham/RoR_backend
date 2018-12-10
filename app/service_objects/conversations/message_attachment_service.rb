module Conversations
  class MessageAttachmentService < ApiService

    def create_attachment_on_message(message, attachment_params)
      message_attachment = message.message_attachments.new

      type = attachment_params[:type]

      attachment_generator = Conversations::Attachments::AttachmentGenerator.new
      attachment = attachment_generator.attachment_for_type(type, attachment_params)

      if attachment_generator.errors.nil?
        message_attachment.attachment = attachment
        if message_attachment.save
          message_attachment
        else
          attachment.destroy if attachment.present?
          register_error(Showoff::ResponseCodes::INTERNAL_ERROR, message_attachment.errors.full_messages.to_sentence) and nil
        end
      else
        error = attachment_generator.errors.first
        register_error(error[:type],error[:message])
      end
    end

  end
end