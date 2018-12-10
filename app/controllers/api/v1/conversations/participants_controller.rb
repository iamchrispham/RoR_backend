module Api
  module V1
    module Conversations
      class ParticipantsController < ApiController
        before_action :set_conversation
        before_action :set_participant, only: [:destroy]

        def index
          success_response(participants: serialized_resource(@conversation&.participants&.activated&.limit(limit)&.offset(offset)&.map(&:participant), ::Conversations::ConversationObjectsSerializer, conversation: @conversation, user: current_api_user))
        end

        def destroy
          unless @conversation.owner.eql?(current_api_user)
            error_response(I18n.t('api.responses.conversations.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            return
          end

          if @participant && !@participant.eql?(current_api_user)
            @conversation.deactivate_for_participant(@participant)

            success_response(deleted: true)
          else
            error_response(I18n.t('api.responses.conversations.participants.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
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

        def set_participant
          @participant ||= @conversation&.participants&.activated&.find_by(participant_id: params[:participant_id] || params[:id])&.participant
        end
      end
    end
  end
end
