module Api::V1
  module Conversations
    class MessagesController < ApiController

      before_action :set_pagination, only: [:index, :destroy]
      before_action :set_conversation

      def index
        messages = message_service.messages_in_conversation(@conversation, nil, nil, nil, current_api_user)
        success_response(messages: serialized_resource(messages.limit(limit).offset(offset), ::Conversations::Messages::MessageSerializer, user: current_api_user))
      end

      def show
        message = message_service.message_in_conversation(@conversation, params[:id], current_api_user)
        if message_service.errors.nil?
          success_response(message: serialized_resource(message, ::Conversations::Messages::MessageSerializer, user: current_api_user))
        else
          error = message_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def create
        message = message_service.create_message_on_conversation(@conversation, current_api_user, message_params)

        if message_service.errors.nil?
          success_response(message: serialized_resource(message, ::Conversations::Messages::MessageSerializer, user: current_api_user))
        else
          error = message_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def destroy
        message_service.delete_message_on_conversation(@conversation, params[:id], current_api_user)
        messages = message_service.messages_in_conversation(@conversation, params[:limit], params[:offset], nil, current_api_user)
        if message_service.errors.nil?
          success_response(messages: serialized_resource(messages, ::Conversations::Messages::MessageSerializer, user: current_api_user))
        else
          error = message_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      private

      def set_conversation
        @conversation = current_api_user.conversations.find_by(id: params[:conversation_id])
        if @conversation.blank?
          error_response(I18n.t('api.responses.conversations.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          return
        end
      end

      def message_service
        @message_service ||= ::Conversations::MessageService.new
      end

      def message_params
        params.require(:message).permit!
      end
    end
  end
end
