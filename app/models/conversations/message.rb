module Conversations
  class Message < ActiveRecord::Base
    self.per_page = 10

    attr_reader :processing_message_objects

    belongs_to :conversation, class_name: 'Conversations::Conversation'
    belongs_to :owner, polymorphic: true

    has_many :messaged_objects, :class_name => 'Conversations::MessagedObject', dependent: :destroy
    has_many :message_attachments, :class_name => 'Conversations::MessageAttachment', dependent: :destroy

    has_one :message_sent_notifier, :class_name => 'Conversations::MessageSentNotifier', foreign_key: 'conversation_message_id', dependent: :destroy

    enum status: [:pending, :sending, :sent, :delivered, :read, :failed]

    after_commit :create_messaged_objects, on: :create, unless: :processing_message_objects

    scope :activated, -> {where(activated: true)}

    before_create :set_pending

    def recipients
      messaged_objects.map(&:recipient).flatten.uniq
    end

    def modifiable?
      !unmodifiable?
    end

    def unmodifiable?
      sending? || sent? || failed?
    end

    def set_status(status)
      self.status = status
    end

    def has_attachments?
      message_attachments.size > 0
    end

    def has_location_attachment?
      has_attachments? && first_attachment.present? && first_attachment.attachment.attachment_type == :location
    end

    def first_attachment
      message_attachments.first
    end

    def formatted_text(user)
      message_owner = owner
      text = self.text.present? ? self.text : nil
      participant_text = message_owner.present? ? ((message_owner.id == user.id && message_owner.class.to_s == user.class.to_s) ? I18n.t('api.responses.conversations.message_you_placeholder') : "#{message_owner.name}:") : nil

      other_participant = conversation.participants.where.not(participant_type: user.class.to_s).first

      if other_participant.present? && other_participant.participant.present?
        participant = other_participant.participant
      else
        participant = message_owner
      end

      message_text = "#{participant_text} #{text}"

      if text == I18n.t('api.responses.conversations.joining_message') && participant == user
        message_text = I18n.t('api.responses.conversations.you_joining_message')
      elsif text == I18n.t('api.responses.conversations.leaving_message') && participant == user
        message_text = I18n.t('api.responses.conversations.you_leaving_message')
      elsif text == I18n.t('api.responses.conversations.joining_message') && participant != user
        message_text = I18n.t('api.responses.conversations.participant_joining_message', participant: participant_text)
      elsif text == I18n.t('api.responses.conversations.leaving_message') && participant != message_owner
        message_text = I18n.t('api.responses.conversations.participant_leaving_message', participant: participant_text)
      elsif text.blank? && has_attachments? && has_location_attachment? && participant == user
        message_text = I18n.t('api.responses.conversations.you_attachment_location_message', type: first_attachment.attachment.attachment_type)
      elsif text.blank? && has_attachments? && participant == user
        message_text = I18n.t('api.responses.conversations.you_attachment_message', type: first_attachment.attachment.attachment_type)
      elsif text.blank? && has_attachments? && has_location_attachment? && participant != user
        message_text = I18n.t('api.responses.conversations.participant_attachment_location_message', participant: participant_text, type: first_attachment.attachment.attachment_type)
      elsif text.blank? && has_attachments? && participant != user
        message_text = I18n.t('api.responses.conversations.participant_attachment_message', participant: participant_text, type: first_attachment.attachment.attachment_type)

      end

      message_text
    end

    def notification_text(user)
      if conversation.event
        I18n.t('notifiers.message_sent.event.message', group: conversation.event.title, message: formatted_text(user))
      elsif conversation.participants.count > 2 && conversation.name
        I18n.t('notifiers.message_sent.event.message', group: conversation.name, message: formatted_text(user))
      else
        I18n.t('notifiers.message_sent.chat.message', message: formatted_text(user))
      end
    end

    private

    def set_pending
      self.status = :pending
      true
    end

    def create_messaged_objects
      @processing_message_objects = true

      participant = conversation.participants.find_by(participant_type: owner_type, participant_id: owner_id)
      if participant.blank?
        read!
        return
      end

      sending!
      participant_id = participant.id
      recipients = conversation.active_participants.where.not(id: participant_id)

      recipients.each do |recipient|
        messaged_object = messaged_objects.new
        messaged_object.recipient = recipient.participant
        messaged_object.save!
      end

      sent!

      create_message_sent_notifier

      delivered!
    end
  end
end
