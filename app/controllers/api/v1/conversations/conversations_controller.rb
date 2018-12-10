module Api::V1
  module Conversations
    class ConversationsController < ApiController
      before_action :set_pagination, only: [:index, :destroy]

      def index
        conversations = conversation_service.conversations_for_participant(current_api_user, limit, offset, term)
        success_response(
          conversations: serialized_resource(conversations.limit(limit).offset(offset), ::Conversations::GoConversationsOverviewSerializer, user: current_api_user, exclude_participants: true)
        )
      end

      def create
        if conversation_params[:message]
          conversation = conversation_service.create_or_update_conversation(current_api_user, conversation_params, nil)
        else
          conversation = conversation_service.create_or_update_conversation_without_message(current_api_user, conversation_params, nil)
        end

        if conversation_service.errors.nil?
          success_response(conversation: serialized_resource(conversation, ::Conversations::GoConversationsOverviewSerializer, user: current_api_user, exclude_participants: true))
        else
          error = conversation_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def show
        conversation = conversation_service.conversation_for_participant(current_api_user, params[:id])
        if conversation_service.errors.nil?
          success_response(conversation: serialized_resource(conversation, ::Conversations::GoConversationsOverviewSerializer, user: current_api_user, exclude_participants: true))
        else
          error = conversation_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def destroy
        conversation_service.leave_conversation_for_participant(current_api_user, params[:id])
        conversations = conversation_service.conversations_for_participant(current_api_user, params[:limit], params[:offset])
        if conversation_service.errors.nil?
          success_response(conversations: serialized_resource(conversations, ::Conversations::GoConversationsOverviewSerializer, user: current_api_user, exclude_participants: true))
        else
          error = conversation_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def mute
        conversation = conversation_service.mute_conversation_for_participant(current_api_user, params[:conversation_id])
        if conversation_service.errors.nil?
          success_response(conversation: serialized_resource(conversation, ::Conversations::GoConversationsOverviewSerializer, conversation: conversation, user: current_api_user), exclude_participants: true)
        else
          error = conversation_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      def unmute
        conversation = conversation_service.unmute_conversation_for_participant(current_api_user, params[:conversation_id])
        if conversation_service.errors.nil?
          success_response(conversation: serialized_resource(conversation, ::Conversations::GoConversationsOverviewSerializer, conversation: conversation, user: current_api_user, exclude_participants: true))
        else
          error = conversation_service.errors.first
          error_response(error[:message], error[:type])
        end
      end

      private

      def conversation_service
        @conversation_service ||= ::Conversations::ConversationsService.new
      end

      def conversation_params
        params.require(:conversation).permit!
      end

      def search_params
        params.require(:search).permit(:term)
      end

      def term
        search_params[:term] if params[:search].present? && search_params[:term].present?
      end
    end
  end
end
