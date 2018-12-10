module Conversations
  class MessageStatusesService < ApiService

    def statuses_in_message(message, limit, offset)
      message.messaged_objects
    rescue Exception => e
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.messages.statuses.not_found'))
    end

    def status_in_message(message, id)
      message.messaged_objects.find(id)
    rescue Exception => e
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.messages.statuses.not_found'))
    end

  end
end