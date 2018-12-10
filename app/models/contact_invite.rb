# frozen_string_literal: true

class ContactInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :go_user, class_name: 'User'

  validates :user, presence: true, uniqueness: { scope: %i[user_id event_id go_user_id phone_number email] }

  before_create :send_platform_invite, unless: :event
  before_create :send_event_invite, if: :event

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
    go_user&.update_caches
  end

  private

  def send_platform_invite
    return true if event

    if phone_number.present?
      message = I18n.t('api.responses.users.contacts.invite.sms_message', name: name, inviter: user.name, link: ENV['BRANCH_URL'])
      send_sms(message)
    end

    UserMailer.delay.invite(email, name, user_id) if errors.empty? && email.present?

    return false unless errors.empty?

    true
  end

  def send_event_invite
    return true unless event

    if phone_number.present?
      message = I18n.t('api.responses.users.contacts.invite.events.sms_message', name: name, inviter: user.name, link: event.branch_link, event: event.title)

      send_sms(message)
    end

    EventMailer.delay.contact_invite(email, name, user.id, event.id) if errors.empty? && email.present?

    return false unless errors.empty?

    true
  end

  def send_sms(message)
    sms_service.send_sms(phone_number, message)

    return true unless sms_service.errors.present?

    error = sms_service.errors.first
    errors.add(:base, error[:message])
  end

  def sms_service
    @sms_service ||= Showoff::Services::SmsService.new
  end
end
