class UpcomingEventNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event
  end

  def self.notification_type
    :event_upcoming
  end

  def subscribers
    User.where(id: event.maybe_attending_users + event.attending_users + event.invited_users)
  end

  def message(target)
    notification_text(target)
  end

  def extra_information(_target)
    {
      event_id: event.id
    }
  end

  def should_notify?(_target)
    true
  end

  def resources(target)
    {
      event: event.cached(target, type: :feed)
    }
  end

  private

  def notification_text(target)
    attendee = event.event_attendees.find_by(user: target)
    if attendee.present?
      if attendee.invited?
        I18n.t('notifiers.event_upcoming_invited', name: event.title, user: event.user.name)
      elsif attendee.going?
        I18n.t('notifiers.event_upcoming_going', name: event.title, user: event.user.name)
      elsif attendee.maybe_going?
        I18n.t('notifiers.event_upcoming_maybe_going', name: event.title, user: event.user.name)
      end
    end
  end
end
