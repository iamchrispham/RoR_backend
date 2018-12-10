module Api::V1
  module Conversations
    class MessageStatusesController < ApiController

      before_action :set_pagination, only: [:index]
      before_action :set_conversation
      before_action :set_message

      def index
        statuses = message_statuses_service.statuses_in_message(@message, params[:limit], params[:offset])
        success_response(statuses: serialized_resource(statuses, ::Conversations::Messages::MessageStatusesSerializer))
      end

      def show
        status = message_statuses_service.status_in_message(@message, params[:id])
        if message_statuses_service.errors.nil?
          success_response(status: serialized_resource(status, ::Conversations::Messages::MessageStatusesSerializer))
        else
          error = message_statuses_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def update
        status = message_statuses_service.status_in_message(@message, params[:id])
        if message_statuses_service.errors.nil?
          begin
            status.status = status_params[:status]
            if status.valid?
              status.save
              success_response(status: serialized_resource(status, ::Conversations::Messages::MessageStatusesSerializer))
            else
              active_record_error_response(status)
            end

          rescue
            error_response(I18n.t('api.responses.conversations.messages.statuses.invalid_status'),Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        else
          error = message_statuses_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      private
      def set_conversation
        @conversation = current_api_user.conversations.find_by(id: params[:conversation_id])
        if @conversation.blank?
          error_response(I18n.t('api.responses.conversations.not_found'),Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          return
        end
      end

      def set_message
        @message = @conversation.messages.find_by(id: params[:message_id])
        if @conversation.blank?
          error_response(I18n.t('api.responses.conversations.messages.not_found'),Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          return
        end
      end

      def message_statuses_service
        @message_statuses_service ||= ::Conversations::MessageStatusesService.new
      end

      def status_params
        params.require(:status).permit!
      end
    end

  end
end