# frozen_string_literal: true

module Api
  module V1
    module Conversations
      class ParticipantsController < ApiController
        before_action :check_conversation_presence
        before_action :check_conversation_owner, only: %i[create destroy]

        def index
          success_response(
            participants: serialized_resource(
              conversation
                &.participants
                &.activated
                &.includes(:participant)
                &.limit(limit)
                &.offset(offset)
                &.map(&:participant),
              ::Conversations::ConversationObjectsSerializer, conversation: conversation, user: current_api_user
            )
          )
        end

        def update
          participant = User.find_by(id: params[:id])

          if participant && conversation.activate_for_participant(participant)
            created_response(created: true)
          else
            participant_not_found
          end
        end

        def destroy
          if participant && !participant.eql?(current_api_user)
            conversation.deactivate_for_participant(participant)

            success_response(deleted: true)
          else
            participant_not_found
          end
        end

        private

        def check_conversation_owner
          conversation_not_found unless conversation.owner.eql?(current_api_user)
        end

        def check_conversation_presence
          conversation_not_found if conversation.blank?
        end

        def participant_not_found
          error_response(
            I18n.t('api.responses.conversations.participants.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND
          )
        end

        def conversation_not_found
          error_response(I18n.t('api.responses.conversations.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def conversation
          @conversation ||= current_api_user.conversations.find_by(id: params[:conversation_id])
        end

        def participant
          @participant ||=
            conversation
            &.participants
            &.activated
            &.find_by(participant_id: params[:participant_id] || params[:id])&.participant
        end
      end
    end
  end
end
