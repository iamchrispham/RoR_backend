module Conversations
  class ConversationsService < ApiService
    def conversations_for_participant_in_event(participant, event, limit, offset)
      participant.conversations.activated.where(event_id: event.id).order(updated_at: :desc).limit(limit).offset(offset)
    end

    def conversation_for_participant(participant, id)
      participant.conversations.find(id)
    rescue StandardError
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.not_found'))
    end

    def conversations_for_participant(participant, limit, offset, term = nil)
      conversations = participant.conversations.activated
      conversations = conversations.for_term(term) if term.present?
      conversations.order(updated_at: :desc).limit(limit).offset(offset)
    end

    def mute_conversation_for_participant(participant, id)
      conversation = participant.conversations.find(id)
      conversation.mute(participant)
      conversation
    rescue StandardError
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.not_found'))
    end

    def unmute_conversation_for_participant(participant, id)
      conversation = participant.conversations.find(id)
      conversation.unmute(participant)
      conversation
    rescue StandardError
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.not_found'))
    end

    def join_conversation_for_participant(participant, id)
      conversation = Conversations::Conversation.find(id)
      conversation.activate_for_participant(participant)
      conversation
    rescue StandardError
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.not_found'))
    end

    def leave_conversation_for_participant(participant, id)
      conversation = participant.conversations.find(id)

      return unless conversation

      conversation.deactivate_for_participant(participant)
      if conversation.participants.empty?
        conversation.destroy
      else
        conversation
      end
    rescue StandardError
      register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.conversations.not_found'))
    end

    def create_or_update_conversation_without_message(current_api_user, conversation_params, event)
      sender = {
        id: current_api_user.id,
        type: current_api_user.class.to_s
      }

      # set up params hashes
      participants_params = conversation_params[:participants]
      participants_params = participants_params.map(&:to_hash).map(&:symbolize_keys!) if participants_params.present? && !participants_params.empty?

      meta_params = conversation_params[:meta_data].except(:image_url, :image_data) unless conversation_params[:meta_data].blank?

      image_url = conversation_params[:meta_data][:image_url] unless conversation_params[:meta_data].blank?
      image_data = conversation_params[:meta_data][:image_data] unless conversation_params[:meta_data].blank?

      conversation = Conversations::Conversation.between(sender, participants_params, event, !event && meta_params ? meta_params[:name] : nil)
      if conversation.blank?
        # create conversation if blank
        conversation = Conversations::Conversation.new(meta_params)
        conversation.activated = true
        conversation.event = event
        conversation.owner = current_api_user
        if conversation.save
          if image_url || image_data
            Showoff::Workers::ImageWorker.perform_async(conversation.class.to_s, conversation.id, url: image_url, data: image_data)
          end
        end
      else
        # update conversation if present
        conversation.update_attributes(meta_params)
        conversation.update_attributes(activated: true)
        if image_url || image_data
          Showoff::Workers::ImageWorker.perform_async(conversation.class.to_s, conversation.id, url: image_url, data: image_data)
        end

        # activate the conversation for the user
        conversation.activate_for_participant(current_api_user)
      end

      # update participants
      # save user to conversation
      updated_participants = []
      updated_participants << conversation.participants.find_or_create_by(participant_id: current_api_user.id, participant_type: current_api_user.class.to_s, conversation: conversation)

      # save other participants to conversation
      participants_params.each do |participant|
        updated_participants << conversation.participants.find_or_create_by(participant_id: participant[:id], participant_type: participant[:type], conversation: conversation)
      end

      # reactivate for the participants who are being sent message. Others who have left conversation will not be activated.
      updated_participants.each do |participant|
        participant.update_attributes(activated: true)
      end

      conversation
    end

    def create_or_update_conversation(current_api_user, conversation_params, event)
      sender = {
        id: current_api_user.id,
        type: current_api_user.class.to_s
      }

      # set up params hashes
      participants_params = conversation_params[:participants]
      participants_params = participants_params.map(&:to_hash).map(&:symbolize_keys!) if participants_params.present? && !participants_params.empty?

      meta_params = conversation_params[:meta_data].except(:image_url, :image_data) unless conversation_params[:meta_data].blank?

      image_url = conversation_params[:meta_data][:image_url] unless conversation_params[:meta_data].blank?
      image_data = conversation_params[:meta_data][:image_data] unless conversation_params[:meta_data].blank?

      message_params = conversation_params[:message] unless conversation_params[:message].blank?

      if participants_params.blank?
        register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'participants'))
        return
      end

      if message_params.blank?
        register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'message'))
        return
      end

      # validate participant types
      participants_params.each do |participant|
        type = participant[:type]
        unless Object.const_defined?(type)
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.invalid_argument', argument: type))
          return
        end
      end

      conversation = Conversations::Conversation.between(sender, participants_params, event, !event && meta_params ? meta_params[:name] : nil)
      if conversation.blank?
        # create conversation if blank
        conversation = Conversations::Conversation.new(meta_params)
        conversation.event = event
        conversation.owner = current_api_user
        if conversation.save
          if image_url || image_data
            Showoff::Workers::ImageWorker.perform_async(conversation.class.to_s, conversation.id, url: image_url, data: image_data)
          end
        end
      else
        # update conversation if present
        conversation.update_attributes(meta_params)
        if image_url || image_data
          Showoff::Workers::ImageWorker.perform_async(conversation.class.to_s, conversation.id, url: image_url, data: image_data)
        end

        # activate the conversation for the user
        conversation.activate_for_participant(current_api_user)
      end

      # update participants
      # save user to conversation
      conversation.participants.find_or_create_by(participant_id: current_api_user.id, participant_type: current_api_user.class.to_s, conversation: conversation)

      # save other participants to conversation
      participants_params.each do |participant|
        conversation.participants.find_or_create_by(participant_id: participant[:id], participant_type: participant[:type], conversation: conversation)
      end

      # update participants
      # save user to conversation
      updated_participants = []
      updated_participants << conversation.participants.find_or_create_by(participant_id: current_api_user.id, participant_type: current_api_user.class.to_s, conversation: conversation)

      # save other participants to conversation
      participants_params.each do |participant|
        updated_participants << conversation.participants.find_or_create_by(participant_id: participant[:id], participant_type: participant[:type], conversation: conversation)
      end

      # reactivate for the participants who are being sent message. Others who have left conversation will not be activated.
      updated_participants.each do |participant|
        participant.update_attributes(activated: true)
      end

      # save message using message service
      message_service = Conversations::MessageService.new
      message = message_service.create_message_on_conversation(conversation, current_api_user, message_params)
      if message_service.errors.nil?
        conversation
      else
        message.destroy if message.present?
        error = message_service.errors.first
        register_error(error[:type], error[:message])
      end
    end
  end
end
