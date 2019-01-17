class EventOwnerAttendeeNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event_attendee

  validates :event_attendee, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event_attendee.user
  end

  def self.notification_type
    :event_owner_attendee
  end

  def subscribers
    [event_attendee.event.user_from_event_owner]
  end

  def message(_target)
    I18n.t('notifiers.event_owner_attendee.message',
           user: event_attendee.user.name,
           event: event_attendee.event.title,
           response: response)
  end

  def extra_information(_target)
    {
      event_attendee_id: event_attendee.id,
      event_id: event_attendee.event.id,
      user_id: event_attendee.user.id
    }
  end

  def should_notify?(target)
    target.notifications_enabled_for('event_owner_attendee')
  end

  def resources(target)
    {
      event_attendee: serialized_resource(event_attendee, ::Events::Attendees::OverviewSerializer, user: target),
      event: event_attendee.event.cached(target, type: :feed)
    }
  end

  private

  def response
    if event_attendee.going?
      I18n.t('notifiers.event_owner_attendee.going')
    elsif event_attendee.not_going?
      I18n.t('notifiers.event_owner_attendee.not_going')
    elsif event_attendee.maybe_going?
      I18n.t('notifiers.event_owner_attendee.maybe_going')
    end
  end
end
