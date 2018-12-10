module Conversations
  class MessageService < ApiService
    def messages_in_conversation(conversation, limit, offset, page, recipient)
      messages = conversation.messages.activated.order(created_at: :desc)

      if limit.present? && offset.present?
        messages = messages.limit(limit).offset(offset)
      elsif page.present?
        messages = messages.paginate(page: page)
      end

      mark_collection_as_read(messages, recipient)

      messages
    end

    def message_in_conversation(conversation, id, recipient)
      message = conversation.messages.find(id)
      mark_as_read(message, recipient)

      message
    rescue Exception => e
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.messages.not_found'))
    end

    def create_message_on_conversation(conversation, owner, message_params)
      #NOTE: In future RSVP version we need to check if event is closed for messages

      # save message
      message = conversation.messages.new(owner: owner, text: message_params[:text])
      if message.save

        attachments = message_params[:attachments]

        unless attachments.blank?
          attachments.each do |attachment|
            attachment_service = Conversations::MessageAttachmentService.new
            attachment = attachment_service.create_attachment_on_message(message, attachment)
            if attachment_service.errors.nil?
              next
            else
              attachment.destroy if attachment.present?
              error = attachment_service.errors.first
              register_error(error[:type], error[:message])
              break
            end
          end
        end

        conversation.updated_at = Time.now
        conversation.activated = true
        conversation.save

        message.reload

        message
      else
        register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, message.errors.full_messages.to_sentence)
      end
    end

    def delete_message_on_conversation(conversation, id, recipient)
      message = message_in_conversation(conversation, id, recipient)
      if message.present?
        message.update_attributes(activated: false)
        true
      end
    rescue Exception => e
      report_error(e)
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.messages.not_found'))
      false
    end

    def mark_collection_as_read(collection, recipient)
      collection.each do |message|
        mark_as_read(message, recipient)
      end
    end

    def mark_as_read(message, recipient)
      messaged_objects = message.messaged_objects.where(recipient: recipient)
      messaged_objects.update_all(status: Conversations::MessagedObject.statuses[:read])
      message.read! if message.messaged_objects.read.count >= message.messaged_objects.count
    end
  end
end
