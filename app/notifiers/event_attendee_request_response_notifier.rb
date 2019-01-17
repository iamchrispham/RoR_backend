class EventAttendeeRequestResponseNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event_attendee_request

  validates :event_attendee_request, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event_attendee_request.event_attendee.event.user_from_event_owner
  end

  def self.notification_type
    :event_attendee_request_response
  end

  def subscribers
    [event_attendee_request.event_attendee.user]
  end

  def message(_target)

    if event_attendee_request.rejected?
      I18n.t('notifiers.event_attendee_request_response.rejected.message',
             user: event_attendee_request.event_attendee.event.user_from_event_owner.name,
             event: event_attendee_request.event_attendee.event.title,
             contribute: contribute)
    else
      I18n.t('notifiers.event_attendee_request_response.message',
             user: event_attendee_request.event_attendee.event.user_from_event_owner.name,
             event: event_attendee_request.event_attendee.event.title,
             response: event_attendee_request.status.to_s.humanize.downcase,
             contribute: contribute)
    end
  end

  def extra_information(_target)
    {
      event_attendee_request_id: event_attendee_request.id,
      event_attendee_id: event_attendee_request.event_attendee.id,
      event_id: event_attendee_request.event_attendee.event.id,
      user_id: event_attendee_request.event_attendee.user.id
    }
  end

  def should_notify?(target)
    target.notifications_enabled_for('event_attendee_request')
  end

  def resources(target)
    {
      event_attendee: serialized_resource(event_attendee_request.event_attendee, ::Events::Attendees::OverviewSerializer, user: target),
      event: event_attendee_request.event_attendee.event.cached(target, type: :feed)
    }
  end

  private
  def contribute
    event_attendee_request.event_attendee.event.contribution_required? && event_attendee_request.accepted? ? I18n.t('notifiers.event_attendee_request_response.contribute') : ''
  end
end
