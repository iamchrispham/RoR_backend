module Conversations
  class Conversation < ActiveRecord::Base
    include Showoff::Concerns::Imagable

    belongs_to :event
    belongs_to :owner, polymorphic: true

    has_many :participants, class_name: 'Conversations::ConversationParticipant', table_name: 'conversation_participants', dependent: :destroy
    has_many :active_participants, -> { where(activated: true, muted: false) }, class_name: 'Conversations::ConversationParticipant', table_name: 'conversation_participants', dependent: :destroy
    has_many :messages, -> { where(activated: true) }, class_name: 'Conversations::Message', dependent: :destroy
    has_many :messaged_objects, class_name: 'Conversations::MessagedObject', through: :messages

    scope :unread, ->(recipient) {
      joins(:messages)
        .joins(:messaged_objects)
        .joins(:participants)
        .where('conversation_participants.activated = true')
        .where(Conversations::MessagedObject.arel_table[:status].not_eq(Conversations::MessagedObject.statuses[:read]))
        .where(messaged_objects: { recipient: recipient })
        .group('conversations.id')
    }

    scope :unread_messages, ->(recipient) {
      joins(:messages)
        .joins(:messaged_objects)
        .where(Conversations::MessagedObject.arel_table[:status].not_eq(Conversations::MessagedObject.statuses[:read]))
        .where(messaged_objects: { recipient: recipient })
    }

    scope :activated, -> { where(activated: true) }

    scope :for_term, ->(text) {
      where('name ILIKE ?', "%#{text}%")
    }

    after_create :update_event_cache

    def update_event_cache
      event&.update_caches
    end

    def unread(recipient)
      objects = messaged_objects.where(recipient: recipient).where.not(status: Conversations::MessagedObject.statuses[:read]).order(created_at: :desc)
      objects.count > 0
    end

    def unread_count(recipient)
      objects = messaged_objects.where(recipient: recipient).where.not(status: Conversations::MessagedObject.statuses[:read]).order(created_at: :desc)
      objects.count
    end

    def formatted_title(_participant)
      return name if name.present?
      participants.map(&:participant).map(&:name).join(', ')
    end

    def latest_message
      messages.order(created_at: :desc).limit(1)
    end

    def muted(participant)
      conversation_participant = participants.find_by(participant_type: participant.class.to_s, participant_id: participant.id)
      conversation_participant.muted
    end

    def mute(participant)
      conversation_participant = participants.where(participant_type: participant.class.to_s, participant_id: participant.id)
      conversation_participant.update_all(muted: true)
    end

    def unmute(participant)
      conversation_participant = participants.where(participant_type: participant.class.to_s, participant_id: participant.id)
      conversation_participant.update_all(muted: false)
    end

    def deactivate_for_participant(participant)
      conversation_participant = participants.where(participant_type: participant.class.to_s, participant_id: participant.id)
      conversation_participant.update_all(activated: false)
    end

    def activate_for_participant(participant)
      conversation_participant = participants.where(participant_type: participant.class.to_s, participant_id: participant.id)
      if conversation_participant.blank?
        conversation_participant = participants.create(participant_type: participant.class.to_s, participant_id: participant.id, conversation: self)
      end
      conversation_participant.update_all(activated: true)
    end

    def activate_for_all_participants
      participants.update_all(activated: true)
    end

    def deactivate_for_all_participants
      participants.update_all(activated: false)
    end

    def self.between(sender, potential_participants, event, name = nil)
      return nil if potential_participants.empty?
      return nil if sender.blank?

      temp_participants = []

      potential_participants.each do |participant|
        conversation_participant = Conversations::ConversationParticipant.find_by(participant_id: participant[:id], participant_type: participant[:type])
        return nil if conversation_participant.blank?
        temp_participants << conversation_participant
      end
      return nil if temp_participants.empty?

      sender_conversation_participant = Conversations::ConversationParticipant.find_by(participant_id: sender[:id], participant_type: sender[:type])
      return nil if sender_conversation_participant.blank?

      temp_participants << sender_conversation_participant
      temp_participants = temp_participants.uniq

      conversations = joins(:participants)
                      .where('conversation_participants.participant_id IN (?) AND conversation_participants.participant_type IN (?)', temp_participants.uniq.map(&:participant_id), temp_participants.uniq.map(&:participant_type)).uniq

      conversations = conversations.where(name: name) if name.present?
      conversations = conversations.where(event_id: event.id) if event.present?
      conversation = conversations.select { |conversation| conversation.participants.map(&:participant).sort_by(&:created_at).eql? temp_participants.map(&:participant).sort_by(&:created_at) }.first

      return conversation unless conversation.blank?
      return nil if conversation.blank?
    end
  end
end
