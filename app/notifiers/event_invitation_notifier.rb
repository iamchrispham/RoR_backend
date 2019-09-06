class EventInvitationNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event_attendee

  validates :event_attendee, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event_attendee.event.event_ownerable
  end

  def self.notification_type
    :event_invitation
  end

  def subscribers
    [event_attendee.user]
  end

  def message(_target)
    I18n.t('notifiers.event_invitation.message',
           user: event_attendee.event.event_ownerable.name,
           event: event_attendee.event.title)
  end

  def extra_information(_target)
    {
      event_attendee_id: event_attendee.id,
      event_id: event_attendee.event.id,
      user_id: event_attendee.user.id
    }
  end

  def should_notify?(target)
    target.notifications_enabled_for('event_invitation')
  end

  def resources(target)
    {
      event_attendee: serialized_resource(event_attendee, ::Events::Attendees::OverviewSerializer, user: target),
      event: event_attendee.event.cached(target, type: :feed)
    }
  end
end
