class EventCancelledNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event
  end

  def self.notification_type
    :event_cancelled
  end

  def subscribers
    event.notifiable_users
  end

  def message(target)
    I18n.t('notifiers.event_cancelled', name: event.title, user: event.event_ownerable.name)
  end

  def extra_information(target)
    {
      event_id: event.id
    }
  end

  def should_notify?(target)
    true
  end

  def resources(target)
    {
      event: event.cached(target, type: :feed)
    }
  end
end
