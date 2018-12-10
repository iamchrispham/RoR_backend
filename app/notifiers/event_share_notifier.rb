class EventShareNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event_share

  validates :event_share, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event_share.user
  end

  def self.notification_type
    :event_share
  end

  def subscribers
    event_share.users
  end

  def message(_target)
    I18n.t('notifiers.event_share.message', user: event_share.user.name)
  end

  def extra_information(_target)
    { event_share_id: event_share.id }
  end

  def should_notify?(target)
    target.notifications_enabled_for('event_share')
  end

  def resources(target)
    { event_share: serialized_resource(event_share, ::Events::Shares::OverviewSerializer, user: target, exclude_users: true) }
  end
end
